local M = {}

local gd = require('gambits/gambit_defines')

local l_funcs = {}
l_funcs.get_highest_tier_buff = function (player, buff)
    local main_job_id = player.instance.main_job_id
    local main_job_level = player.instance.main_job_level
    local sub_job_id = player.instance.sub_job_id
    local sub_job_level = player.instance.sub_job_level
    local highest = nil
    local spell = nil

    for i, b in ipairs(buff) do
        spell = res.spells:with('name', b)
        if spell ~= nil and player.spells[spell.id] then
            if ((spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= main_job_level) or (spell.levels[sub_job_id] ~= nil and spell.levels[sub_job_id] <= sub_job_level)) and ((spell.targets['Party'] or spell.targets['Enemy'] or spell.targets['NPC'])) then
                highest = b
                break
            end
        end
    end

    return highest, spell
end

function cond(buff_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if params == nil then return false, params end
            local buff = gd.buffs[buff_name]
            if buff == nil then
                return false, params
            else
                local pms = params
                pms.bundle['spell'] = {}
                local buff, spell = l_funcs.get_highest_tier_buff(player, buff)
                pms.bundle.spell.name = buff
                pms.bundle.spell.id = spell.id
                pms.bundle.spell.prefix = spell.prefix
                return pms.bundle.spell.name ~= nil, pms
            end
        end)
    }
    return obj
end

M.cond = cond

return M