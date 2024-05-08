_addon.name = 'Gambit'
_addon.author = 'Geno'
_addon.version = '0.1.0'
_addon.commands = {'gb', 'gambit'}

packets = require('packets')
res = require('resources')
local gd = require('gambits/gambit_defines')
require('queues')
require('sets')
require('lists')

local loaded_gambits = {}

local var_cache = {}

--cool down between inputting an action
local gcd_delay = 3.1
--delay to wait before a character is considered no longer moving
--this is important for casting right after moving
local is_moving_delay = 0.3
local player_casting = false

local paused = false

local last_tick = os.clock()
local gcd_timer = 0
local first_loop = true
local chat_q = {}
local commands_q = Q{}
local player = {}
local logged_in = false
local g_bundle = {}
g_bundle.conditions = {}

player.ja_recasts = {}
player.ma_recasts = {}
player.instance = {}
player.buffs = {}
player.spells = {}
player.self = {}
player.is_moving = false
player.last_move_time = 0

Queue = {}
function Queue.new ()
    return {first = 0, last = -1}
end

function Queue.push_to_top (list, value)
  local first = list.first - 1
  list.first = first
  list[first] = value
end

function Queue.push (list, value)
  local last = list.last + 1
  list.last = last
  list[last] = value
end

function Queue.pop(list)
  local first = list.first
  if first > list.last then return nil end
  local value = list[first]
  list[first] = nil        -- to allow garbage collection
  list.first = first + 1
  return value
end

-- Save copied tables in `copies`, indexed by original table.
function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--Taken from Gearswap, credit to Byrthnoth
-----------------------------------------------------------------------------------
--Name: assemble_action_packet(target_id,target_index,category,spell_id)
--Desc: Puts together an "action" packet (0x1A)
--Args:
---- target_id - The target's ID
---- target_index - The target's index
---- category - The action's category. (3 = MA, 7 = WS, 9 = JA, 16 = RA, 25 = MS)
---- spell_ID - The current spell's ID
-----------------------------------------------------------------------------------
--Returns:
---- string - An action packet. First four bytes are dummy bytes.
-----------------------------------------------------------------------------------
function assemble_action_packet(target_id,target_index,category,spell_id,arrow_offset)
    local outstr = string.char(0x1A,0x08,0,0)
    outstr = outstr..string.char( (target_id%256), math.floor(target_id/256)%256, math.floor( (target_id/65536)%256) , math.floor( (target_id/16777216)%256) )
    outstr = outstr..string.char( (target_index%256), math.floor(target_index/256)%256)
    outstr = outstr..string.char( (category%256), math.floor(category/256)%256)
    
    if category == 16 then
        spell_id = 0
    end
        
    outstr = outstr..string.char( (spell_id%256), math.floor(spell_id/256)%256)..string.char(0,0) .. 'fff':pack(0,0,0)
    return outstr
end

local use_command = (function(command, target)
    if command == "--bundle" then
        return (
            function(player, params)
                windower.console.write('DOING input //'..params.bundle.spell.name..' '..params.bundle.spell.target)

                local unify_prefix = {['/ma'] = '/ma', ['/magic']='/ma',['/jobability'] = '/ja',['/ja']='/ja',['/item']='/item',['/song']='/ma',
                    ['/so']='/ma',['/ninjutsu']='/ma',['/weaponskill']='/ws',['/ws']='/ws',['/ra']='/ra',['/rangedattack']='/ra',['/nin']='/ma',
                    ['/throw']='/ra',['/range']='/ra',['/shoot']='/ra',['/monsterskill']='/ms',['/ms']='/ms',['/pet']='/ja',['Monster']='Monster',['/bstpet']='/ja'}

                if params.bundle.spell.target_by_id then 
                    local outgoing_action_category_table = {['/ma']=3,['/ws']=7,['/ja']=9,['/ra']=16,['/ms']=25}
                    
                    if params.bundle.spell.target_id and params.bundle.spell.target_index and params.bundle.spell.prefix and params.bundle.spell.id then
                        local action_packet = assemble_action_packet(params.bundle.spell.target_id, params.bundle.spell.target_index, outgoing_action_category_table[unify_prefix[params.bundle.spell.prefix]], params.bundle.spell.id, nil)
                        --windower.packets.inject_outgoing(0x1A, action_packet)
                        windower.send_command('input '..tostring(unify_prefix[params.bundle.spell.prefix]).." "..tostring(params.bundle.spell.name).." "..tostring(params.bundle.spell.target_id))
                        if unify_prefix[params.bundle.spell.prefix] == '/ja' then
                            return 1.2
                        end
                        --windower.send_command('input /assist <me>')
                    end
                else
                    windower.send_command('input //'..params.bundle.spell.name..' '..params.bundle.spell.target) 
                    if unify_prefix[params.bundle.spell.prefix] == '/ja' then
                        return 1.2
                    end
                end
            end)
    elseif target == nil then
        return (function() windower.send_command('input //'..command) end)
    elseif target == "me" or target == "self" then
        return (function() windower.send_command('input //'..command..' <me>') end)
    elseif target == "t" or target == "target" then
        return (function() windower.send_command('input //'..command..' <t>') end)
    elseif target ~= nil then
		return (function() windower.send_command('input //'..command..' '..target) end)
	end
end)

local set_global_condition = (function(variable_name, value)
    return (function(player, params)
        local v = value
        local vn = variable_name
        if v == "--bundle" then
            v = params.bundle.g_cond_value
        end
        if vn == "--bundle" then
            vn = params.bundle.g_cond_key
        end
        if v == nil or vn == nil then
            windower.add_to_chat(128, "Global Variables cannot be nil Key=Value: "..tostring(vn).."="..tostring(v))
            return 0.1
        end
        windower.add_to_chat(128, "Setting "..tostring(vn).."="..tostring(v))
        g_bundle.conditions[vn] = v
        return 0.1
    end)
end)

local get_global_condition = (function(variable_name)
    return (function()
        return g_bundle.conditions[variable_name]
    end)
end)

local queue_use_commands = (function(...)
    local commands = L{...}
    return (function(player, params)
        windower.add_to_chat(150, "Queued "..tostring(commands:length()).." commands.")
        local count = 1
        local cmd_len = commands:length()
        while count <= cmd_len do
            local packed = {}
            packed.command = commands[count]
            packed.params = params 
            commands_q:push(packed)
            count = count + 1
        end
        return 0
    end)
end)

--taken from Byrth, GearSwap
function refresh_buff_active(bufflist)
    buffarr = {}
    for i,v in pairs(bufflist) do
        if res.buffs[v] then -- For some reason we always have buff 255 active, which doesn't have an entry.
            local buff = res.buffs[v]['en']:lower()
            if buffarr[buff] then
                buffarr[buff] = buffarr[buff] +1
            else
                buffarr[buff] = 1
            end
            
            if buffarr[v] then
                buffarr[v] = buffarr[v] +1
            else
                buffarr[v] = 1
            end
        end
    end
    return buffarr
end

--This is taken from gearswap and modified for Gambit
-----------------------------------------------------------------------------------
--Name: pathsearch()
--Args:
---- files_list - table of strings of the file name to search.
-----------------------------------------------------------------------------------
--Returns:
---- path of a valid file, if it exists. False if it doesn't.
-----------------------------------------------------------------------------------
function pathsearch(files_list)

    -- base directory search order:
    -- windower
    
    -- sub directory search order:
    -- stacks
    
    local gearswap_data = windower.addon_path .. 'stacks/'
    local gearswap_appdata = (os.getenv('APPDATA') or '') .. '/Windower/Gambit/stacks/'
    
    local search_path = {
        [1] = gearswap_data,
        [2] = gearswap_appdata,
        [3] = gearswap_data .. player.self.name .. '/',
        [4] = gearswap_appdata .. player.self.name .. '/',
        [5] = windower.addon_path
    }
    
    local user_path
    local normal_path

    for _,basepath in ipairs(search_path) do
        if windower.dir_exists(basepath) then
            for i,v in ipairs(files_list) do
                if v ~= '' then
                    if include_user_path then
                        user_path = basepath .. include_user_path .. '/' .. v
                    end
                    normal_path = basepath .. v
                    
                    if user_path and windower.file_exists(user_path) then
                        return user_path,basepath,v
                    elseif normal_path and windower.file_exists(normal_path) then
                        return normal_path,basepath,v
                    end
                end
            end
        end
    end
    
    return false
end

function include_user(str, load_include_in_this_table)
    if not (type(str) == 'string') then
        error('\nGambit: include() was passed an invalid value ('..tostring(str)..'). (must be a string)', 2)
    end
    
    str = str:lower()
    if type(package.loaded[str]) == 'table' then
        return package.loaded[str]
    elseif T{'pack'}:contains(str) then
        return
    end
    
    if str:sub(-4)~='.lua' then str = str..'.lua' end
    local path, loaded_values = pathsearch({str})
    
    if not path then
        error('\nGambit: Cannot find the include file ('..tostring(str)..').', 2)
    end
    
    local f, err = loadfile(path)

    if err ~= nil or f == nil then
        windower.add_to_chat(158, 'Include Error: '..tostring(e))
    else
        --print('Gambit: Included '..tostring(f)..' file.')
    end

    if f and not err then
        if load_include_in_this_table and type(load_include_in_this_table) == 'table' then
            setmetatable(load_include_in_this_table, {__index=user_env._G})
            setfenv(f, load_include_in_this_table)
            pcall(f, load_include_in_this_table)
            return load_include_in_this_table
        else
            setfenv(f,file_env)
            return f()
        end
    else
        error('\nGambit: Error loading file ('..tostring(str)..'): '..err, 2)
    end
end

function load_stacks()
    loaded_gambits = {}

    local job_id = windower.ffxi.get_player().main_job_id

    local path,base_dir,filename
    if not path then
        local long_job = res.jobs[job_id].english
        local short_job = res.jobs[job_id].english_short
        local tab = {player.self.name..'_'..short_job..'.lua',player.self.name..'-'..short_job..'.lua',
            player.self.name..'_'..long_job..'.lua',player.self.name..'-'..long_job..'.lua',
            player.self.name..'.lua',short_job..'.lua',long_job..'.lua','default.lua'}
        path,base_dir,filename = pathsearch(tab)
    end

    local loaded_file, e = loadfile(path)
    if e ~= nil or loaded_file == nil then
        windower.add_to_chat(158, 'Error: '..tostring(e))
    else
        print('Gambit: Loaded '..filename..' file.')
    end
    file_env = {
        include = include_user,
        require = require,
        ipairs = ipairs,
        string = string,
        table = table,
        tostring=tostring,
        windower = windower,
        use_command = use_command,
        set_global_condition = set_global_condition,
        get_global_condition = get_global_condition,
        queue_use_commands = queue_use_commands,
        g_bundle = g_bundle,
        Q = Q,
        S = S,
        L = L,
        math = math,
        deepcopy = deepcopy,
        os = os,
        res = res,
        var_cache = var_cache,
		type=type,
		rawget=rawget,
    }
    setfenv(loaded_file, file_env)
    local status, plugin = pcall(loaded_file)
    if status ~= nil and not status then
        windower.add_to_chat(158, 'Failed to load file '..plugin)
    end
    registered_gambits = file_env.registered_gambits
    for i, gbt in ipairs(registered_gambits) do
        local gam = gbt
        gam.initalize_gambit()
        table.insert(loaded_gambits, gam)
    end
end

windower.register_event('login', function()
    player.self = windower.ffxi.get_mob_by_target("me")
    load_stacks()
    logged_in = true
end)

windower.register_event('load', function()
    player.self = windower.ffxi.get_mob_by_target("me")
    load_stacks()
    logged_in = true
end)

windower.register_event('logout', function()
    logged_in = false
    first_loop = true
end)

windower.register_event('unload', function()
    logged_in = false
    first_loop = true
end)

windower.register_event('addon command', function(command, ...)
    command = command and command:lower() or nil
    args = T{...}
    table.insert(args, 1, command)
    local next = next
    if next(args) ~= nil then
        if args[1] == 'stop' then
            paused = true
        end
        if args[1] == 'start' then
            paused = false
        end
        --gb txt Genoxd set trash jas
        if args[1] == 'txt' then
            table.remove(args, 1)
            local speaker = table.remove(args, 1)
            local text = table.concat(args, ' ')
            local message = '('..speaker:gsub("^%l", string.upper)..') '..text
            handleChatString(message)
            return 
        end
    end

end)

function pre_load()
    chat_q = Queue.new()
    commands_q:pop()
    player.spells = windower.ffxi.get_spells()
    player.self = windower.ffxi.get_mob_by_target("me")
    player.last_move_time = 0
end

windower.register_event('prerender', function()
    if paused then return end
    if not logged_in then return end
    if(first_loop) then
        first_loop = false
        pre_load()
    end
    
    local current_time = os.clock()

    if(current_time - last_tick > 10) then
        --wonder if this is worth it, could make them reload instead
        player.spells = windower.ffxi.get_spells()
    end

    if (current_time - last_tick) > 0.1 and (current_time > gcd_timer) and not player_casting then
        last_tick = os.clock()
        
        player.instance = windower.ffxi.get_player()
        player.ja_recasts = windower.ffxi.get_ability_recasts()
        player.ma_recasts = windower.ffxi.get_spell_recasts()
        player.buffs = refresh_buff_active(player.instance['buffs'])
		player.info = windower.ffxi.get_info()
        local oldSelf = player.self
        player.self = windower.ffxi.get_mob_by_target("me")
        if player.self == nil then return end
        if player.self ~= nil and player.self.pet_index ~= nil then
            player.pet = windower.ffxi.get_mob_by_index(player.self.pet_index)
        else
            player.pet = nil
        end
        if oldSelf == nil then
            return ---------------------------------------------------- ADDED THIS
        end
        local posChange = (oldSelf.x ~= player.self.x or oldSelf.z ~= player.self.z)
        if posChange then
            player.last_move_time = last_tick
            player.is_moving = true
        else
            local dt_last_move = last_tick - player.last_move_time
            player.is_moving = dt_last_move < is_moving_delay
        end

        local dequeued_command = commands_q:pop()
        if dequeued_command ~= nil and dequeued_command.command ~= nil then
            
            local delay = dequeued_command.command(player, dequeued_command.params)
            if delay ~=nil then
                gcd_timer = current_time + delay
            else
                gcd_timer = current_time + gcd_delay
            end
            return
        end

        local msgsToPop = 0
        for i, gamb in ipairs(loaded_gambits) do
            local tmp_chat_q = deepcopy(chat_q)
            --simple timed triggers
            if(gamb.trigger_type == gd.trigger_types.timed) then
                if gamb.should_proc() then
                    gamb.proc()
                end
            --complex triggers or state based
            elseif(gamb.trigger_type == gd.trigger_types.trigger) then
                local dequeued = nil
                local msgCount = 0
                local params = {}
                params.g_bundle = g_bundle
                repeat
                    --need to handle chat log messages here
                    dequeued = Queue.pop(tmp_chat_q)
                    params.chatStr = dequeued
                    --bundle is reset. This gives each gambit the ability to pass temp data unique to this iteration
                    params.bundle = {}
                    local pr, pm = gamb.should_proc(player, params)
                    params = pm
                    if pr then
                        if gamb.after_proc then
                            local para = gamb.after_proc(player, params)
                            g_bundle = para.g_bundle
                        end
                        if(gamb.proc(player, params)) then
                            gcd_timer = current_time + gcd_delay
                            local first_cmd = commands_q:pop()
                            if first_cmd ~= nil and first_cmd.command ~= nil then
                                local delay = first_cmd.command(player, first_cmd.params)
                                if delay ~= nil then
                                    gcd_timer = current_time + delay
                                end
                            end
                            msgsToPop = msgCount + 1
                            while msgsToPop > 0 do
                                Queue.pop(chat_q)
                                msgsToPop = msgsToPop - 1
                            end

                            return
                        end
                    end
                    msgCount = msgCount + 1
                    --limit this loop to 10 messages so rendering is not blocked
                until(dequeued == nil or msgCount >= 10)
                msgsToPop = msgCount
            end
        end
        while msgsToPop > 0 do
            Queue.pop(chat_q)
            msgsToPop = msgsToPop - 1
        end
    end
end)

function handleChatString(message)
    Queue.push(chat_q, message)
    --processing for just gd.trigger_types.chat
    for i, gamb in ipairs(loaded_gambits) do
        if(gamb.trigger_type == gd.trigger_types.chat) then
            if(gamb.should_proc(player, message)) then
                gamb.proc(player, message)
            end
        end
    end
end

windower.register_event('incoming text', function(original,modified,original_mode,modified_mode, blocked)
    --handles party chat
    if type(original) == 'string' and modified_mode == 5 then
        handleChatString(original)
    end
end)

windower.register_event('chat message', function(message,sender,mode,gm)
    --handles tells
    if mode == 3 or mode == 4 then
        if type(message) == 'string' then
            handleChatString('('..sender..') '..message)
        end
    end
end)

windower.register_event('outgoing chunk', function(id, data, modified, injected, blocked)
    local packet = packets.parse('outgoing', data)
    if (id == 0x01A) then
        --spell cast
        if packet.Category == 3 then
            gcd_timer = os.clock() + gcd_delay
        else
            --job ability
            gcd_timer = os.clock() + 1.1
        end
    end
end)

windower.register_event('incoming chunk', function(id, data)
    if id == 0x076 then
        handleBuffChangePacket(data)
        return
    end
    if id == 0x028 then
        local action_message = packets.parse('incoming', data)
        if(action_message["Actor"] == player.self.id) then
            if action_message["Category"] == 4 then
                player_casting = false
                gcd_timer = os.clock() + gcd_delay
            elseif action_message["Category"] == 8 then
                player_casting = true
                if action_message["Target 1 Action 1 Message"] == 0 then
                    player_casting = false
                    gcd_timer = os.clock() + gcd_delay
                end
            end
        end
    end
end)

windower.register_event('zone change', function(new_id, old_id)
    windower.send_command('input //lua u gambit')
end)

-----------------------------------------------------------------------------------
--Name: convert_buff_list(bufflist)
--Args:
---- bufflist (table): List of buffs from windower.ffxi.get_player()['buffs']
-----------------------------------------------------------------------------------
--Returns:
---- buffarr (table)
---- buffarr is indexed by the string buff name and has a value equal to the number
---- of that string present in the buff array. So two marches would give
---- buffarr.march==2.
-----------------------------------------------------------------------------------
function convert_buff_list(bufflist)
    local buffarr = {}
    for i,id in pairs(bufflist) do
        if res.buffs[id] then -- For some reason we always have buff 255 active, which doesn't have an entry.
            local buff = res.buffs[id]['en']:lower()
            if buffarr[buff] then
                buffarr[buff] = buffarr[buff] +1
            else
                buffarr[buff] = 1
            end
            
            if buffarr[id] then
                buffarr[id] = buffarr[id] +1
            else
                buffarr[id] = 1
            end
        end
    end
    return buffarr
end

function handleBuffChangePacket(data)
    partybuffs = {}
    --windower.add_to_chat(128, 'pkt')
    for i = 0,4 do
        if data:unpack('I',i*48+5) == 0 then
            break
        else
            local index = data:unpack('H',i*48+5+4)
            partybuffs[index] = {
                id = data:unpack('I',i*48+5+0),
                index = data:unpack('H',i*48+5+4),
                buffs = {}
            }
            for n=1,32 do
                partybuffs[index].buffs[n] = data:byte(i*48+5+16+n-1) + 256*( math.floor( data:byte(i*48+5+8+ math.floor((n-1)/4)) / 4^((n-1)%4) )%4)
            end
            --windower.add_to_chat(128, "Index: "..tostring(index))
            local mob = windower.ffxi.get_mob_by_index(index)
            --windower.add_to_chat(128, "Mob: "..tostring(mob.name))
            local new_buffs = convert_buff_list(partybuffs[index].buffs)
            for k, v in pairs(new_buffs) do
                --windower.add_to_chat(128, "Buff Pkt: "..tostring(k)..':'..tostring(v))
            end
            
            --[[ if alliance[1] then
                local cur_player
                for n,m in pairs(alliance[1]) do
                    if type(m) == 'table' and m.mob and m.mob.index == index then
                        cur_player = m
                        break
                    end
                end
                
                if cur_player then
                    --cur_player.buffactive = new_buffs
                end
            end
            --]]
        end
    end
end
