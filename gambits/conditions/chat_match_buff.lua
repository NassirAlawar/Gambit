local M = {}

local gd = require('gambits/gambit_defines')

function get_highest_tier_buff(player, buff)
    local main_job_id = player.instance.main_job_id
    local main_job_level = player.instance.main_job_level
    local sub_job_id = player.instance.sub_job_id
    local sub_job_level = player.instance.sub_job_level
    local highest = nil

    for i, b in ipairs(buff) do
        local spell = res.spells:with('name', b)
        if spell ~= nil then
            if ((spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= main_job_level) or (spell.levels[sub_job_id] ~= nil and spell.levels[sub_job_id] <= sub_job_level)) then
                highest = b
                break
            end
        end
    end

    return highest
end

function chat_match_buff(required_speaker)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if params == nil then return false, params end
            if params.chatStr == nil then return false, params end
            local str = params.chatStr:lower()
            local speaker, speech = string.match(str, "%((%a+)%) (.*)")
            if speaker == nil or speech == nil then
                return false, params
            elseif required_speaker == nil or (required_speaker == speaker) then
                speech = speech:lower():gsub( "%W", "" )
                local buff = gd.buffs[speech]
                if buff == nil then
                    return false, params
                else
                    local pms = params
                    pms.bundle['spell'] = {}
                    pms.bundle.spell.name = get_highest_tier_buff(player, buff)
                    pms.bundle.spell.target = speaker
                    return pms.bundle.spell.name ~= nil, pms
                end
            else
                return false, params
            end
        end)
    }
    return obj
end

M.chat_match_buff = chat_match_buff

return M