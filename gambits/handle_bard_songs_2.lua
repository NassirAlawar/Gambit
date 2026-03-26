gd = require('gambits/gambit_defines')

local M = {}

local l_funcs = {}

List = Q{}


Defaults = {}
Defaults.display = {}
Defaults.display.text = {}
Defaults.display.pos = {}
Defaults.display.pos.x = 17
Defaults.display.pos.y = windower.get_windower_settings().y_res-250
Defaults.display.text.font = 'Courier New'
Defaults.display.text.red = 80
Defaults.display.text.green = 180
Defaults.display.text.blue = 200
Defaults.display.text.alpha = 255
Defaults.display.text.size = 12
Defaults.visible = true
Defaults.display.visible = true

settings = Defaults

Defaults2 = deepcopy(Defaults)
Defaults2.display.pos.x = 400

settings2 = deepcopy(settings)
settings2.display.pos.x = 400

repeat_box = textboxes.new('${current_string}',Defaults2.display,settings2)
repeat_box.current_string = ''
repeat_box:show()

action_box = textboxes.new('${current_string}',Defaults.display,settings)
action_box.current_string = ''
action_box:show()




function peekQ(q)
    if q:empty() then
        return nil
    end
    local cq = deepcopy(q)
    local result = cq:pop()
    return result
end

ActionBundle = {}
function ActionBundle.new()
local ab = {}
ab["actions"] = Q{}
ab["isRepeating"] = false
ab["repeatDelay"] = 0
ab["nextTime"] = 0
return ab
end

local action_q = Q{}
local repeat_q = Q{}
local action_processing = false
local cast_started = false
local current_action = nil

local nightingale_id = res.job_abilities:with('name', 'Nightingale').id
local troubadour_id = res.job_abilities:with('name', 'Troubadour').id
local marcato_id = res.job_abilities:with('name', 'Marcato').id
local soulvoice_id = res.job_abilities:with('name', 'Soul Voice').id
local clarion_id = res.job_abilities:with('name', 'Clarion Call').id
local pianissimo_id = res.job_abilities:with('name', 'Pianissimo').id

l_funcs.find_player_by_partial_name = function(partial)
    local lower_partial = partial:lower()
    local mob = windower.ffxi.get_mob_by_name(partial)
    if mob ~= nil then
        return mob
    end
    local best = nil
    for _, v in pairs(windower.ffxi.get_mob_array()) do
        if v.valid_target and (not v.is_npc or v.spawn_type == 14) then
            if v.name:lower():find('^' .. lower_partial) then
                if best == nil or #v.name < #best.name then
                    best = v
                end
            end
        end
    end
    return best
end

l_funcs.pianissimo_active = function()
    local p = windower.ffxi.get_player()
    if p and p.buffs then
        if p.buffs['Pianissimo'] or p.buffs['pianissimo'] then
            return true
        end
    end
    return false
end

local base_song_duration = 120
local marcato_bonus = 20
--local duration_multiplier = 2.02
local duration_multiplier_mod = 0
local song_bonus = {}
local song_duration_gear = {}
local song_duration_gear_default = 0.96
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

song_bonus['Victory March'] = song_bonus['March']
song_bonus['Advancing March'] = song_bonus['March']
song_bonus['Honor March'] = song_bonus['March'] + 1 -- +1 due to Marsyas having +50% duration aka +5
song_bonus['Valor Minuet'] = song_bonus['Minuet']
song_bonus['Valor Minuet II'] = song_bonus['Minuet']
song_bonus['Valor Minuet III'] = song_bonus['Minuet']
song_bonus['Valor Minuet IV'] = song_bonus['Minuet']
song_bonus['Valor Minuet V'] = song_bonus['Minuet']
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
    local job_points = player.instance.job_points[res.jobs[main_job_id].ens:lower()].jp_spent
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
            if ((not song_set:contains(spell.name)) and ((spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= main_job_level) or (spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= job_points) or (spell.levels[sub_job_id] ~= nil and spell.levels[sub_job_id] <= sub_job_level))) then
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

local initiators = {}

initiators["clear"] = function(input_q, player)
    if peekQ(input_q) ~= "songs" then
        return
    end
    input_q:pop()
    repeat_q:clear()
    action_q:clear()
end

initiators["which"] = function(input_q, player)
    if peekQ(input_q) ~= "songs" then
        return
    end
    input_q:pop()

    local repeats = deepcopy(repeat_q)
    local count = 0
    for value in repeats:it() do
        if type(value) ~= "number" then
            local nextTime = value.nextTime
            local actions = deepcopy(value.actions)
            local action = actions:pop()
            local output = "Singing: "
            local target = ""
            while action ~= nil do
                if action.is_dummy == false and action.id ~= pianissimo_id and action.id ~= nightingale_id and action.id ~= troubadour_id and action.id ~= marcato_id and action.id ~= soulvoice_id and action.id ~= clarion_id then 
                    target = tostring(action.target)
                    output = output..tostring(action.name)..", "
                elseif action.id == nightingale_id then
                    output = output.."[JA] "
                end
                action = actions:pop()
            end
            output = output:sub(1, -3)
            output = output.." on "..target.." in "..tostring(nextTime - os.clock())
            windower.send_command('wait '..tostring(count*1.5)..';input /p '..output)
            count = count + 1
        end
    end

end

initiators["keep"] = function(input_q, player)
    if peekQ(input_q) ~= "singing" then
        return
    end
    input_q:pop()

    local actionBundle = ActionBundle.new()
    local maxSongs = 4;
    local inputList = deepcopy(input_q)
    local tmp_action_q = Q{}
    local use1hr = false
    local useJa = false
    local use_jas = get_global_condition("useJA")()
    local use_1hr = get_global_condition("use1Hr")()
    local target = "me"
    local song_l = L{}

    local num_songs = 0
    for value in inputList:it() do
        if type(value) ~= "number" then
            if value == "1hr" then
                use1hr = use_1hr
            elseif value == "ja" then
                useJa = use_jas
            elseif gd.buffs[value:lower()] ~= nil then
                -- we got a song so count the number here so we can deal with inserting dummy songs
                num_songs = num_songs + 1
            else
                local txt = value:gsub("^%l", string.upper)
                local mob = l_funcs.find_player_by_partial_name(txt)
                if mob ~= nil then
                    target = mob.name
                else
                    windower.send_command('input /p No one matches "' .. value .. '"')
                    return
                end
            end
        end
    end

    if use1hr then
        tmp_action_q:push(l_funcs.get_ja_action("Clarion Call"))
        tmp_action_q:push(l_funcs.get_ja_action("Soul Voice"))
        maxSongs = maxSongs + 1;
    end
    if useJa then
        tmp_action_q:push(l_funcs.get_ja_action("Nightingale"))
        tmp_action_q:push(l_funcs.get_ja_action("Troubadour"))
        tmp_action_q:push(l_funcs.get_ja_action("Marcato"))
    end

    local hasValidSong = false
    local songCount = 0
    local lowest_bonus = 999

    for value in inputList:it() do
        if type(value) ~= "number" then
            if value ~= "1hr" and value ~= "ja" and songCount < maxSongs then
                local buff = gd.buffs[value:lower()]
                if buff ~= nil then
                    hasValidSong = true
                    local buff_name, spell = l_funcs.get_highest_tier_buff(player, buff, S(song_l))
                    song_l:append(spell)
                    if target ~= "me" then
                        tmp_action_q:push(l_funcs.get_ja_action("Pianissimo"))
                    end

                    local song_time_multiplier = 1.0
                    if song_bonus[spell.name] then
                        song_time_multiplier = song_time_multiplier + song_bonus[spell.name]*0.1
                    end
                    if song_duration_gear[spell.name] then
                        song_time_multiplier = song_time_multiplier + song_duration_gear[spell.name]
                    else
                        song_time_multiplier = song_time_multiplier + song_duration_gear_default
                    end
                    if song_time_multiplier < lowest_bonus then
                        lowest_bonus = song_time_multiplier
                    end

                    local act = {}
                    act.is_dummy = false
                    act.cmd = use_command(spell.name, target)
                    act.started = false
                    act.target = target
                    act.name = spell.name
                    act.id = res.spells:with('name', spell.name).id
                    tmp_action_q:push(act)
                    songCount = songCount + 1

                    -- handle inserting dummy songs
                    local dummy_song_one = get_global_condition("dummy_song_one")()
                    local dummy_song_two = get_global_condition("dummy_song_two")()
                    local dummy_song_three = get_global_condition("dummy_song_three")()
                    -- no need with Prime
                    local do_dummy_songs = get_global_condition("do_dummy_songs")()
                    if do_dummy_songs and songCount < num_songs then
                        if songCount == 2 then
                            if target ~= "me" then
                                tmp_action_q:push(l_funcs.get_ja_action("Pianissimo"))
                            end
                            local act = {}
                            act.is_dummy = true
                            act.cmd = use_command(dummy_song_one, target)
                            act.started = false
                            act.target = target
                            act.name = dummy_song_one
                            act.id = res.spells:with('name', dummy_song_one).id
                            tmp_action_q:push(act)
                        elseif songCount == 3 then
                            if target ~= "me" then
                                tmp_action_q:push(l_funcs.get_ja_action("Pianissimo"))
                            end
                            local act = {}
                            act.is_dummy = true
                            act.cmd = use_command(dummy_song_two, target)
                            act.started = false
                            act.target = target
                            act.name = dummy_song_two
                            act.id = res.spells:with('name', dummy_song_two).id
                            tmp_action_q:push(act)
                        elseif songCount == 4 then
                            if target ~= "me" then
                                tmp_action_q:push(l_funcs.get_ja_action("Pianissimo"))
                            end
                            local act = {}
                            act.is_dummy = true
                            act.cmd = use_command(dummy_song_three, target)
                            act.started = false
                            act.target = target
                            act.name = dummy_song_three
                            act.id = res.spells:with('name', dummy_song_three).id
                            tmp_action_q:push(act)
                        end
                    end
                end
            end
        end
    end

    if lowest_bonus == 999 then
        lowest_bonus = 0
    end

    local song_multiplier = duration_multiplier_mod + lowest_bonus
    
    -- TODO: if useJa or if NiTro is up with enough time left to cast
    if useJa then
        -- local time = math.floor(2*(base_song_duration*song_multiplier)) - 60
        -- if time < 605 then
        --     time = 605
        -- end
        local time = 610
        actionBundle.repeatDelay = time
    else
        actionBundle.repeatDelay = math.floor(base_song_duration*song_multiplier) - 60
    end

    actionBundle.nextTime = os.clock()
    actionBundle.isRepeating = true

    local tmp_copy_q = Q{}
    if hasValidSong then
        local action = tmp_action_q:pop()
        while action ~= nil do
            if type(action) ~= "number" then
                tmp_copy_q:push(action)
                action = tmp_action_q:pop()
            end
        end
        actionBundle.actions = tmp_copy_q
    end
    repeat_q:push(actionBundle)
end

initiators["sing"] = function(input_q, player)
    local maxSongs = 5;
    local inputList = deepcopy(input_q)
    local tmp_action_q = Q{}
    local use1hr = false
    local useJa = false
    local use_jas = get_global_condition("useJA")()
    local use_1hr = get_global_condition("use1Hr")()
    local target = "me"
    local song_l = L{}
    
    local num_songs = 0
    for value in inputList:it() do
        if type(value) ~= "number" then
            if value == "1hr" then
                use1hr = use_1hr
            elseif value == "ja" then
                useJa = use_jas
            elseif gd.buffs[value:lower()] ~= nil then
                -- we got a song so count the number here so we can deal with inserting dummy songs
                num_songs = num_songs + 1
            else
                local txt = value:gsub("^%l", string.upper)
                local mob = l_funcs.find_player_by_partial_name(txt)
                if mob ~= nil then
                    target = mob.name
                else
                    windower.send_command('input /p No one matches "' .. value .. '"')
                    return
                end
            end
        end
    end

    if use1hr then
        tmp_action_q:push(l_funcs.get_ja_action("Clarion Call"))
        tmp_action_q:push(l_funcs.get_ja_action("Soul Voice"))
    end
    if useJa then
        tmp_action_q:push(l_funcs.get_ja_action("Nightingale"))
        tmp_action_q:push(l_funcs.get_ja_action("Troubadour"))
        tmp_action_q:push(l_funcs.get_ja_action("Marcato"))
    end
    
    local hasValidSong = false
    local songCount = 0

    for value in inputList:it() do
        if type(value) ~= "number" then
            if value ~= "1hr" and value ~= "ja" and songCount < maxSongs then
                local buff = gd.buffs[value:lower()]
                if buff ~= nil then
                    hasValidSong = true
                    local buff_name, spell = l_funcs.get_highest_tier_buff(player, buff, S(song_l))
                    song_l:append(spell)
                    if target ~= "me" then
                        tmp_action_q:push(l_funcs.get_ja_action("Pianissimo"))
                    end
                    local act = {}
                    act.is_dummy = false
                    act.cmd = use_command(spell.name, target)
                    act.started = false
                    act.target = target
                    act.name = spell.name
                    act.id = res.spells:with('name', spell.name).id
                    tmp_action_q:push(act)
                    songCount = songCount + 1
                    -- handle inserting dummy songs
                    local dummy_song_one = get_global_condition("dummy_song_one")()
                    local dummy_song_two = get_global_condition("dummy_song_two")()
                    local dummy_song_three = get_global_condition("dummy_song_three")()
                    -- no need with Prime
                    local do_dummy_songs = get_global_condition("do_dummy_songs")()
                    if do_dummy_songs and songCount < num_songs then
                        if songCount == 2 then
                            if target ~= "me" then
                                tmp_action_q:push(l_funcs.get_ja_action("Pianissimo"))
                            end
                            local act = {}
                            act.is_dummy = true
                            act.cmd = use_command(dummy_song_one, target)
                            act.started = false
                            act.target = target
                            act.name = dummy_song_one
                            act.id = res.spells:with('name', dummy_song_one).id
                            tmp_action_q:push(act)
                        elseif songCount == 3 then
                            if target ~= "me" then
                                tmp_action_q:push(l_funcs.get_ja_action("Pianissimo"))
                            end
                            local act = {}
                            act.is_dummy = true
                            act.cmd = use_command(dummy_song_two, target)
                            act.started = false
                            act.target = target
                            act.name = dummy_song_two
                            act.id = res.spells:with('name', dummy_song_two).id
                            tmp_action_q:push(act)
                        elseif songCount == 4 then
                            if target ~= "me" then
                                tmp_action_q:push(l_funcs.get_ja_action("Pianissimo"))
                            end
                            local act = {}
                            act.is_dummy = true
                            act.cmd = use_command(dummy_song_three, target)
                            act.started = false
                            act.target = target
                            act.name = dummy_song_three
                            act.id = res.spells:with('name', dummy_song_three).id
                            tmp_action_q:push(act)
                        end
                    end
                end
            end
        end
    end
    
    if hasValidSong then
        local action = tmp_action_q:pop()
        while action ~= nil do
            if type(action) ~= "number" then
                action_q:push(action)
                action = tmp_action_q:pop()
            end
        end
    end
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
        local performed_id = act['param']
        local expected = peekQ(action_q)
        if expected ~= nil and expected.id == performed_id then
            action_q:pop()
        end

        local actionstxt = ''
        for value in action_q:it() do
            actionstxt = actionstxt..tostring(value.name)..'\n'
        end
        action_box.current_string = actionstxt

        action_processing = false
    elseif cat == 8 then
        cast_started = not cast_started
        if not cast_started then
            -- Spell casting got interrupted
            if current_action ~= nil then
                if current_action.target == "me" then
                    -- nothing
                else
                    if not l_funcs.pianissimo_active() then
                        local act = l_funcs.get_ja_action("Pianissimo")
                        action_q:insert(1, act)
                    end
                end

                local actionstxt = ''
                for value in action_q:it() do
                    actionstxt = actionstxt..tostring(value.name)..'\n'
                end
                action_box.current_string = actionstxt
                
            end
            action_processing = false
        end
    elseif cat == 4 then
        -- Spell finished. Determine performed spell id.
        local spell_id = act['param']
        if spell_id == nil and act['targets'] and act['targets'][1] and act['targets'][1]['actions'] and act['targets'][1]['actions'][1] then
            spell_id = act['targets'][1]['actions'][1]['param']
        end

        local expected = peekQ(action_q)
        if expected ~= nil and spell_id ~= nil and expected.id == spell_id then
            action_q:pop()
        else
            if expected ~= nil and expected.target ~= "me" and not l_funcs.pianissimo_active() then
                local pian = l_funcs.get_ja_action("Pianissimo")
                action_q:insert(1, pian)
            end
        end

        local actionstxt = ''
        for value in action_q:it() do
            actionstxt = actionstxt..tostring(value.name)..'\n'
        end
        action_box.current_string = actionstxt

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
            
            good_to_go = good_to_go and (status['en'] == "Idle" or status['en'] == "Engaged")
            good_to_go = good_to_go and not player.is_moving

            -- TODO: spell distances for BRD and target spells

            if not good_to_go or action_processing then
                return false
            end

            current_action = peekQ(action_q)

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
                            action_q:pop()
                        end
                        action_processing = false
                    else
                        action_processing = true
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
                        local speaker_lower = string.lower(speaker)
                        local is_leader = false
                        if type(leader) == "string" then
                            is_leader = speaker_lower == string.lower(leader)
                        else
                            for l in pairs(leader) do
                                if string.lower(l) == speaker_lower then
                                    is_leader = true
                                    break
                                end
                            end
                        end
                        if not is_leader and speaker_lower ~= string.lower(player.instance.name) then
                            return peekQ(action_q) ~= nil, params
                        end
                    end
                end

                local text_q = Q{}

                for p in string.gmatch(speech, "[^%s]+") do
                    text_q:push(p)
                end
                local txt = text_q:pop()
                if initiators[txt] ~= nil then
                    initiators[txt](text_q, player)
                end
            end

            local re_txt = ''
            for value in repeat_q:it() do
                if type(value) ~= "number" then
                    re_txt = re_txt..tostring(value.isRepeating)..' : '..tostring(os.clock() - value.nextTime)..'\n'
                    if value.isRepeating and value.nextTime <= os.clock() then
                        value.nextTime = os.clock() + value.repeatDelay
                        local actions = deepcopy(value.actions)
                        local action = actions:pop()
                        while action ~= nil do
                            action_q:push(action)
                            action = actions:pop()
                        end
                    end
                end
            end

            repeat_box.current_string = re_txt

            local actionstxt = ''

            for value in action_q:it() do
                actionstxt = actionstxt..tostring(value.name)..'\n'
            end

            action_box.current_string = actionstxt

            return peekQ(action_q) ~= nil, params
        end)
    }
    return obj
end

M.cond = cond

return M