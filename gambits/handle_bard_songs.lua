gd = require('gambits/gambit_defines')

local M = {}

local l_funcs = {}

List = {}
function List.new ()
  return {first = 0, last = -1}
end

function List.pushleft (list, value)
    local first = list.first - 1
    list.first = first
    list[first] = value
  end
  
  function List.pushright (list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
  end
  
  function List.popleft (list)
    local first = list.first
    if first > list.last then return nil end
    local value = list[first]
    list[first] = nil        -- to allow garbage collection
    list.first = first + 1
    return value
  end

  function List.peekleft (list)
    return list[list.first]
  end
  
  function List.popright (list)
    local last = list.last
    if list.first > last then return nil end
    local value = list[last]
    list[last] = nil         -- to allow garbage collection
    list.last = last - 1
    return value
  end

local action_q = List.new()
local keep_q = List.new()
local action_processing = false
local cast_started = false
local current_action = nil

local nightingale_id = res.job_abilities:with('name', 'Nightingale').id
local troubadour_id = res.job_abilities:with('name', 'Troubadour').id
local marcato_id = res.job_abilities:with('name', 'Marcato').id
local soulvoice_id = res.job_abilities:with('name', 'Soul Voice').id
local clarion_id = res.job_abilities:with('name', 'Clarion Call').id
local pianissimo_id = res.job_abilities:with('name', 'Pianissimo').id

local base_song_duration = 120
local marcato_bonus = 20
--local duration_multiplier = 2.02
local duration_multiplier_mod = 0
local song_bonus = {}
local song_duration_gear = {}
song_bonus['Paeon'] = 7
song_bonus['Ballad'] = 8
song_bonus['Minne'] = 7
song_bonus['Minuet'] = 8
song_bonus['Madrigal'] = 8
song_bonus['Prelude'] = 8
song_bonus['Mambo'] = 7
song_bonus['Aubade'] = 7
song_bonus['Pastoral'] = 7
song_bonus['Fantasia'] = 7
song_bonus['Operetta'] = 7
song_bonus['Capriccio'] = 7
song_bonus['Round'] = 7
song_bonus['Gavotte'] = 7
song_bonus['March'] = 8
song_bonus['Etude'] = 7
song_bonus['Carol'] = 7
song_bonus['Hymnus'] = 7
song_bonus['Mazurka'] = 7
song_bonus['Sirvente'] = 7
song_bonus['Dirge'] = 7
song_bonus['Scherzo'] = 8
song_bonus['Aria of Passion'] = 5
song_duration_gear['Aria of Passion'] = 0.46

song_bonus['Victory March'] = song_bonus['March']
song_duration_gear['Victory March'] = 0.96
song_bonus['Advancing March'] = song_bonus['March']
song_duration_gear['Advancing March'] = 0.46
song_bonus['Honor March'] = song_bonus['March'] - 4
song_duration_gear['Honor March'] = 0.96
song_bonus['Valor Minuet'] = song_bonus['Minuet']
song_bonus['Valor Minuet II'] = song_bonus['Minuet']
song_bonus['Valor Minuet III'] = song_bonus['Minuet']
song_bonus['Valor Minuet IV'] = song_bonus['Minuet']
song_bonus['Valor Minuet V'] = song_bonus['Minuet']
song_duration_gear['Valor Minuet V'] = 0.46
song_bonus['Blade Madrigal'] = song_bonus['Madrigal']
song_bonus['Sword Madrigal'] = song_bonus['Madrigal']
song_bonus["Mage's Ballad"] = song_bonus['Ballad']
song_bonus["Mage's Ballad II"] = song_bonus['Ballad']
song_bonus["Mage's Ballad III"] = song_bonus['Ballad']


l_funcs.get_highest_tier_buff = function(player, buff, song_set)
    local main_job_id = player.instance.main_job_id
    local main_job_level = player.instance.main_job_level
    local sub_job_id = player.instance.sub_job_id
    local sub_job_level = player.instance.sub_job_level
    local highest = nil
    local spell = nil

    song_set = song_set.map(song_set, (function(s)
        return s.name
    end))

    local hasHonorMarch = get_global_condition("hasHonorMarch")()
    local hasAria = get_global_condition("hasAria")()

    for i, b in ipairs(buff) do
        spell = res.spells:with('name', b)
        if spell ~= nil and (player.spells[spell.id] or (spell.name == "Honor March" and hasHonorMarch) or (spell.name == "Aria of Passion" and hasAria)) then
            if ((not song_set:contains(spell.name)) and (spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= main_job_level) or (spell.levels[sub_job_id] ~= nil and spell.levels[sub_job_id] <= sub_job_level)) then
                highest = b
                break
            end
        end
    end

    return highest, spell
end

l_funcs.get_ja_action = function(name)
    local act = {}
    act.cmd = (function (player, params)
        local abil = res.job_abilities:with('name', name)
        if player.ja_recasts[abil.recast_id] == 0 then
            use_command(name, "me")(player, params)
            return true
        else
            return false
        end
    end)
    act.started = false
    act.target = "me"
    act.name = name
    act.id = res.job_abilities:with('name', name).id

    return act
end

l_funcs.ja_recast_ready = function(player, name)
    local abil = res.job_abilities:with('name', name)
    return player.ja_recasts[abil.recast_id] == 0
end


windower.register_event('action', function(act)
    if act['actor_id'] ~= windower.ffxi.get_mob_by_target("me").id then
        return
    end
    -- 6 = JA
    -- 8 = start or interrupted
    -- 4 = spell
    local cat = act['category']
    if cat == 6 then
        List.popleft(action_q)
        action_processing = false
    elseif cat == 8 then
        cast_started = not cast_started
        if not cast_started then
            -- Spell casting got interrupted
            if current_action ~= nil then
                if current_action.target == "me" then
                    --List.pushleft(action_q, current_action)
                else
                    local act = l_funcs.get_ja_action("Pianissimo")
                    List.pushleft(action_q, act)
                end
            end
            action_processing = false
        end
    elseif cat == 4 then
        List.popleft(action_q)
        action_processing = false
        cast_started = false
    end
end)

function cond(leader_var)
    local obj = {
        trigger_type = gd.trigger_types.trigger,
        proc = (function(player, params)

            local status = statuses[player.instance.status]
            
            local good_to_go = true
            
            good_to_go = good_to_go and player.buffs["silence"] == nil
            good_to_go = good_to_go and player.buffs["petrification"] == nil
            good_to_go = good_to_go and player.buffs["stun"] == nil
            good_to_go = good_to_go and player.buffs["charm"] == nil
            good_to_go = good_to_go and player.buffs["sleep"] == nil
            good_to_go = good_to_go and player.buffs["terror"] == nil
            good_to_go = good_to_go and player.buffs["mute"] == nil
            good_to_go = good_to_go and player.buffs["Omerta"] == nil
			good_to_go = good_to_go and player.buffs["Mounted"] == nil
            
            good_to_go = good_to_go and status['en'] == "Idle" or status['en'] == "Engaged"
            good_to_go = good_to_go and not player.is_moving

            -- TODO: spell distances for BRD and target spells

            if not good_to_go or action_processing then
                return false
            end

            current_action = List.peekleft(action_q)

            if current_action ~= nil then
                if current_action.target ~= "me" then
                    -- handle Pianissimo cast distance 20 (400)
                    local mob = windower.ffxi.get_mob_by_name(current_action.target)
                    -- doing greater than or equal to give a 0.5 unit buffer
                    if mob == nil or mob.distance >= 400 then
                        return false
                    end
                end
                local res = current_action.cmd(player, params)
                if res ~= nil then
                    if not res then
                        local c_id = current_action.id
                        if c_id == nightingale_id or c_id == troubadour_id or c_id == marcato_id or c_id == soulvoice_id or c_id == clarion_id then
                            List.popleft(action_q)
                        end
                        action_processing = false
                    end
                    return res
                end
            end
            return true
        end),
        initalize_gambit = (function()
        end),
        should_proc = (function(player, params)
            if params ~= nil and params.chatStr ~= nil then
                local str = params.chatStr:lower()
                local speaker, speech = string.match(str, "%((%a+)%) (.*)")
                if leader_var ~= nil then
                    local leader = get_global_condition(leader_var)()
                    if leader ~= nil then
                        if string.lower(speaker) ~= string.lower(leader) then
                            return List.peekleft(action_q) ~= nil, params
                        end
                    end
                end
                local count = 0
                local keeping = false
                local valid = false
                local clearing = false
                local which = false
                local text_q = Q{}
                
                for p in string.gmatch(speech, "[^%s]+") do
                    repeat
                        local part = p:gsub("%s+", ""):lower()
                        if count == 0 then
                            if part == "keep" then
                                count = count + 1
                                keeping = true
                                valid = true
                                break
                            elseif part == "sing" then
                                count = count + 1
                                valid = true
                                break
                            elseif part == "clear" then
                                count = count + 1
                                clearing = true
                                valid = true
                                break
                            elseif part == "which" then
                                count = count + 1
                                which = true
                                valid = true
                                break
                            end
                        elseif count == 1 then
                            if keeping and part == "singing" then
                                count = count + 1
                                valid = true
                                break
                            elseif clearing and part == "songs" then
                                keep_q = nil
                                keep_q = List.new()
                                valid = false
                                windower.send_command('input /p Cleared all songs')
                                break
                            elseif which and part == "songs" then
                                local temp_k_q = deepcopy(keep_q)
                                local song_stack = List.popleft(temp_k_q)
                                if song_stack == nil then
                                    windower.send_command("input /p I'm not singing any songs")
                                end
                                local wait_delay = 0
                                while song_stack ~= nil do
                                    local s = List.popleft(song_stack.q)
                                    local msg = "Singing: "
                                    local t = ""
                                    while s ~= nil do
                                        if s.id ~= pianissimo_id then
                                            t = s.target
                                            msg = msg..s.name..", "
                                        end
                                        s = List.popleft(song_stack.q)
                                    end
                                    msg = msg:sub(1, -3)
                                    msg = msg.." on "..tostring(t)
                                    windower.send_command('wait '..tostring(wait_delay)..';input /p '..msg)
                                    wait_delay = wait_delay + 2
                                    song_stack = List.popleft(temp_k_q)
                                end
                                valid = false
                                break
							end
                        end

                        count = count + 1

                        --we got keep singing or sing so now we're on to songs and target
                        text_q:push(part)

                        break
                    until true

                    if not valid then
                        break
                    end
                end

                if not valid then
                    return List.peekleft(action_q) ~= nil, params
                end

                local target = "me"
                local txt = text_q:pop()
                local song_l = L{}
                while txt ~= nil do
                    txt = txt:gsub("^%l", string.upper)
                    local mob = windower.ffxi.get_mob_by_name(txt)
                    -- then this is a player name
                    if mob ~= nil then
						windower.add_to_chat(123, 'n: '..tostring(mob.name))
                        target = mob.name
                    else
                        local buff = gd.buffs[txt:lower()]
                        if buff ~= nil then
                            local buff_name, spell = l_funcs.get_highest_tier_buff(player, buff, S(song_l))
                            song_l:append(spell)
                        end
                    end
                    txt = text_q:pop()
                end

                local actually_using_jas = false
                local use_jas = get_global_condition("useJA")()
                if use_jas and song_l:length() > 0 and l_funcs.ja_recast_ready(player, "Nightingale") and l_funcs.ja_recast_ready(player, "Troubadour") and l_funcs.ja_recast_ready(player, "Marcato") then
                    local act = l_funcs.get_ja_action("Nightingale")
                    List.pushright(action_q, act)
                    local act = l_funcs.get_ja_action("Troubadour")
                    List.pushright(action_q, act)
                    local act = l_funcs.get_ja_action("Marcato")
                    List.pushright(action_q, act)
                    actually_using_jas = true
                end

                local k_q = List.new()

                local lowest_bonus = 999

                for sng in song_l:it() do
                    if target ~= "me" then
                        local act = l_funcs.get_ja_action("Pianissimo")
                        if keeping then
                            List.pushright(k_q, act)
                        end
                        List.pushright(action_q, act)
                    end
                    local song_time_multiplier = 1.0
                    if song_bonus[sng.name] then
                        song_time_multiplier = song_time_multiplier + song_bonus[sng.name]*0.1
                    end
                    if song_duration_gear[sng.name] then
                        song_time_multiplier = song_time_multiplier + song_duration_gear[sng.name]
                    end
                    if song_time_multiplier < lowest_bonus then
                        lowest_bonus = song_time_multiplier
                    end
                    local act = {}
                    act.cmd = use_command(sng.name, target)
                    act.started = false
                    act.target = target
                    act.name = sng.name
                    act.id = res.spells:with('name', sng.name).id
                    List.pushright(action_q, act)
                    if keeping then
                        List.pushright(k_q, act)
                    end
                end
                if keeping then
                    local keep_obj = {}
                    if lowest_bonus == 999 then
                        lowest_bonus = 0
                    end
                    local song_multiplier = duration_multiplier_mod + lowest_bonus
                    if actually_using_jas then
                        keep_obj.repeat_time = math.floor(base_song_duration*song_multiplier)
                        keep_obj.next_time = os.clock() + math.floor(2*(base_song_duration*song_multiplier)) + marcato_bonus
                    else
                        keep_obj.next_time = os.clock() + math.floor(base_song_duration*song_multiplier)
                        keep_obj.repeat_time = math.floor(base_song_duration*song_multiplier)
                    end
                    keep_obj.q = k_q
                    List.pushright(keep_q, keep_obj)
                end
            end

            if List.peekleft(action_q) == nil and List.peekleft(keep_q) ~= nil and List.peekleft(keep_q).next_time < os.clock() then
                local temp_k_q = deepcopy(keep_q)

                local actually_using_jas = false
                local use_jas = get_global_condition("useJA")()
                if use_jas and l_funcs.ja_recast_ready(player, "Nightingale") and l_funcs.ja_recast_ready(player, "Troubadour") and l_funcs.ja_recast_ready(player, "Marcato") then
                    local act = l_funcs.get_ja_action("Nightingale")
                    List.pushright(action_q, act)
                    local act = l_funcs.get_ja_action("Troubadour")
                    List.pushright(action_q, act)
                    local act = l_funcs.get_ja_action("Marcato")
                    List.pushright(action_q, act)
                    actually_using_jas = true
                end
                local song_stack = List.popleft(temp_k_q)
                while song_stack ~= nil do
                    local s = List.popleft(song_stack.q)
                    while s ~= nil do
                        List.pushright(action_q, s)
                        s = List.popleft(song_stack.q)
                    end
                    song_stack = List.popleft(temp_k_q)
                end
                if actually_using_jas then
                    List.peekleft(keep_q).next_time = os.clock() + math.floor(2*List.peekleft(keep_q).repeat_time) + marcato_bonus
                else
                    List.peekleft(keep_q).next_time = os.clock() + List.peekleft(keep_q).repeat_time
                end
            end

            return List.peekleft(action_q) ~= nil, params
        end)
    }
    return obj
end

M.cond = cond

return M