gd = require('gambits/gambit_defines')

local M = {}

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
local action_processing = false
local cast_started = false
local current_action = nil

function get_highest_tier_buff(player, buff, song_set)
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

    for i, b in ipairs(buff) do
        spell = res.spells:with('name', b)
        if spell ~= nil and (player.spells[spell.id] or (spell.name == "Honor March" and hasHonorMarch)) then
            if ((not song_set:contains(spell.name)) and (spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= main_job_level) or (spell.levels[sub_job_id] ~= nil and spell.levels[sub_job_id] <= sub_job_level)) then
                highest = b
                break
            end
        end
    end

    return highest, spell
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
                    local act = {}
                    act.cmd = use_command("Pianissimo", "me")
                    act.started = false
                    act.target = "me"
                    act.id = res.job_abilities:with('name', 'Pianissimo').id

                    
                    --List.pushleft(action_q, current_action)
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
            
            good_to_go = good_to_go and status['en'] == "Idle" or status['en'] == "Engaged"
            good_to_go = good_to_go and not player.is_moving

            -- TODO: spell distances for BRD and target spells
            --good_to_go = good_to_go and (mob ~= nil and spell_distances[spell.range] ~= nil and mob.distance < spell_distances[spell.range])

            if not good_to_go or action_processing then
                return false
            end

            --action_processing = true
            --local copy = deepcopy()
            --print_q(action_q, "pre-proc")
            current_action = List.peekleft(action_q)
            --List.pushleft(action_q, current_action)
            --print_q(action_q, "post-proc")
            --print_q(action_q)
            if current_action ~= nil then
                --action_q:insert(0, action)
                --print_q(action_q, "insert")
                windower.add_to_chat(128, 'Using '..tostring(current_action.id))
                local res = current_action.cmd(player, params)
                if res ~= nil then
                    if not res then
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
                local text_q = Q{}
                
                for p in string.gmatch(speech, "[^%s]+") do
                    repeat
                        local part = p:gsub("%s+", ""):lower()
                        if count == 0 then
                            if part == "keep" then
                                keeping = true
                                break
                            elseif part == "sing" then
                                valid = true
                                break
                            end
                        elseif count == 1 and keeping then
                            if part == "singing" then
                                valid = true
                                break
                            else
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
                        target = mob.name
                    else
                        local buff = gd.buffs[txt:lower()]
                        if buff ~= nil then
                            local buff_name, spell = get_highest_tier_buff(player, buff, S(song_l))
                            song_l:append(spell)
                        end
                    end
                    txt = text_q:pop()
                end

                local use_jas = get_global_condition("useJA")()
                if use_jas and song_l:length() > 0 then

                    local act = {}
                    act.cmd = (function (player, params)
                        local abil = res.job_abilities:with('name', "Nightingale")
                        if player.ja_recasts[abil.recast_id] == 0 then
                            use_command("Nightingale", "me")(player, params)
                            return true
                        else
                            return false
                        end
                    end)
                    act.started = false
                    act.target = "me"
                    act.id = res.job_abilities:with('name', 'Nightingale').id

                    List.pushright(action_q, act)

                    local act = {}
                    act.cmd = (function (player, params)
                        local abil = res.job_abilities:with('name', "Troubadour")
                        if player.ja_recasts[abil.recast_id] == 0 then
                            use_command("Troubadour", "me")(player, params)
                            return true
                        else
                            return false
                        end
                    end)
                    act.started = false
                    act.target = "me"
                    act.id = res.job_abilities:with('name', 'Troubadour').id

                    List.pushright(action_q, act)

                    local act = {}
                    act.cmd = (function (player, params)
                        local abil = res.job_abilities:with('name', "Marcato")
                        if player.ja_recasts[abil.recast_id] == 0 then
                            use_command("Marcato", "me")(player, params)
                            return true
                        else
                            return false
                        end
                    end)
                    act.started = false
                    act.target = "me"
                    act.id = res.job_abilities:with('name', 'Marcato').id

                    List.pushright(action_q, act)

                end

                for sng in song_l:it() do
                    if target ~= "me" then
                        local act = {}
                        act.cmd = use_command("Pianissimo", "me")
                        act.started = false
                        act.target = "me"
                        act.id = res.job_abilities:with('name', 'Pianissimo').id

                        List.pushright(action_q, act)
                    end
                    local act = {}
                    act.cmd = use_command(sng.name, target)
                    act.started = false
                    act.target = target
                    act.id = res.spells:with('name', sng.name).id
                    List.pushright(action_q, act)
                end
                --print_q(action_q, "start")
            end

            return List.peekleft(action_q) ~= nil, params
        end)
    }
    return obj
end

M.cond = cond

return M