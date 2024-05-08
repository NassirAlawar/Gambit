local M = {}

local gd = require('gambits/gambit_defines')

local l_funcs = {}
l_funcs.get_highest_tier_buff = function (player, buff, is_target_self, allow_self)
    local main_job_id = player.instance.main_job_id
    local main_job_level = player.instance.main_job_level
    local sub_job_id = player.instance.sub_job_id
    local sub_job_level = player.instance.sub_job_level
    local highest = nil
    local spell = nil

    for i, b in ipairs(buff) do
        spell = res.spells:with('name', b)
        if spell ~= nil and player.spells[spell.id] then
            if ((spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= main_job_level) or (spell.levels[sub_job_id] ~= nil and spell.levels[sub_job_id] <= sub_job_level)) and (is_target_self or allow_self or (spell.targets['Party'] or spell.targets['Enemy'] or spell.targets['NPC'])) then
                highest = b
                break
            end
        end
    end

    return highest, spell
end

function titleCase(first, rest)
    return first:upper()..rest:lower()
end

function cond(required_speaker)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if params == nil then return false, params end
            if params.chatStr == nil then return false, params end
            local str = params.chatStr:lower()
            local speaker, speech = string.match(str, "%((%a+)%) (.*)")
            local target_by_id = false
            local target_index = nil
            local target_id = nil
            local allow_self = false
            if speaker == nil or speech == nil then
                return false, params
            elseif required_speaker == nil or (required_speaker == speaker) then
                local words = string.split(speech, " ")
                local last_word = words[#words]:lower():gsub("%W", "")
                speech = speech:lower():gsub("%W", "")
                if last_word and (last_word == 't') then
                    speaker = string.gsub(speaker, "(%a)([%w_']*)", titleCase)
                    target_index = windower.ffxi.get_mob_by_name(speaker)['target_index']
                    local mob = windower.ffxi.get_mob_by_index(target_index)
                    target = mob.name
                    target_id = mob.id
                    speech = speech:sub(1, -2)
                    target_by_id = true
                elseif last_word and windower.ffxi.get_mob_by_name(last_word) then
                    speech = speech:gsub(last_word, "")
                    target = last_word
                else
                    target = speaker
                    allow_self = true
                end

                local buff = gd.buffs[speech]
                if buff == nil then
                    return false, params
                else
                    local pms = params
                    pms.bundle['spell'] = {}
                    local buff, spell = l_funcs.get_highest_tier_buff(player, buff, (target == player.self.name), allow_self)
                    if allow_self and spell.targets['Party'] == nil then
                        target = player.self.name
                    end
                    pms.bundle.spell.name = buff
                    pms.bundle.spell.id = spell.id
                    pms.bundle.spell.prefix = spell.prefix
                    pms.bundle.spell.target_by_id = target_by_id
                    pms.bundle.spell.target_id = target_id
                    pms.bundle.spell.target_index = target_index
                    pms.bundle.spell.target = target
                    return pms.bundle.spell.name ~= nil, pms
                end
            else
                return false, params
            end
        end)
    }
    return obj
end

M.cond = cond

return M