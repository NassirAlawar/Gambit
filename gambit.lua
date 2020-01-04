_addon.name = 'Gambit'
_addon.author = 'Geno'
_addon.version = '0.1.0'
_addon.cmd = {'gb', 'gambit'}

packets = require('packets')
res = require('resources')
local gd = require('gambits/gambit_defines')

local loaded_gambits = {}

local var_cache = {}

--cool down between inputting an action
local gcd_delay = 3.1
--delay to wait before a character is considered no longer moving
--this is important for casting right after moving
local is_moving_delay = 1
local player_casting = false

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


local use_command = (function(command, target)
    if command == "--bundle" then
        return (function(player, params)
					windower.console.write('DOING input //'..params.bundle.spell.name..' '..params.bundle.spell.target)
                    windower.send_command('input //'..params.bundle.spell.name..' '..params.bundle.spell.target) 
                end)
    elseif target == nil then
        return (function() windower.send_command('input //'..command) end)
    elseif target == "me" or target == "self" then
        return (function() windower.send_command('input //'..command..' <me>') end)
    elseif target == "t" or target == "target" then
        return (function() windower.send_command('input //'..command..' <t>') end)
    end
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

function load_stack(filename)
    loaded_gambits = {}
    local loaded_file, e = loadfile(windower.addon_path..'stacks/'..filename..'.lua')
    if e ~= nil then
        windower.add_to_chat(158, 'Error: '..tostring(e))
    end
    local file_env = {
        require = require,
        ipairs = ipairs,
        string = string,
        table = table,
        windower = windower,
        use_command = use_command,
        res = res,
        var_cache = var_cache
    }
    setfenv(loaded_file, file_env)
    local status, plugin = pcall(loaded_file)
    if status ~= nil and not status then
        windower.add_to_chat(158, 'Failed to load file')
    end
    registered_gambits = file_env.registered_gambits
    for i, gbt in ipairs(registered_gambits) do
        local gam = gbt
        gam.initalize_gambit()
        table.insert(loaded_gambits, gam)
    end
end

load_stack("test_gambits")

local last_tick = os.clock()
local gcd_timer = 0
local first_loop = true
local chat_q = {}
local player = {}
player.ja_recasts = {}
player.ma_recasts = {}
player.instance = {}
player.buffs = {}
player.spells = {}
player.self = {}
player.is_moving = false
player.last_move_time = 0

function pre_load()
    chat_q = Queue.new()
    player.spells = windower.ffxi.get_spells()
    player.self = windower.ffxi.get_mob_by_target("me")
    player.last_move_time = 0
end

windower.register_event('prerender', function()
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
        local oldSelf = player.self
        player.self = windower.ffxi.get_mob_by_target("me")
        
        local posChange = (oldSelf.x ~= player.self.x or oldSelf.z ~= player.self.z)
        if posChange then
            player.last_move_time = last_tick
            player.is_moving = true
        else
            local dt_last_move = last_tick - player.last_move_time
            player.is_moving = dt_last_move < is_moving_delay
        end
        
        for i, gamb in ipairs(loaded_gambits) do
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
                repeat
                    --need to handle chat log messages here
                    dequeued = Queue.pop(chat_q)
                    params.chatStr = dequeued
                    --bundle is reset. This gives each gambit the ability to pass temp data unique to this iteration
                    params.bundle = {}
                    local pr, pm = gamb.should_proc(player, params)
                    params = pm
                    if pr then
                        if(gamb.proc(player, params)) then
                            gcd_timer = current_time + gcd_delay
                            return
                        end
                    end
                    msgCount = msgCount + 1
                    --limit this loop to 10 messages so rendering is not blocked
                until(dequeued == nil or msgCount >= 10)
            end
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

windower.register_event('incoming chunk', function(id, data)
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

