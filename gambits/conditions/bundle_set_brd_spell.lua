local M = {}

local gd = require('gambits/gambit_defines')

function get_highest_tier_buff(player, buff, is_target_self, allow_self)
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

function cond(var_name1, var_name2, var_name3, var_name4, var_name5, var_name6)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local song1 = params.bundle[var_name1]
            local song2 = params.bundle[var_name2]
            local song3 = params.bundle[var_name3]
            local song4 = params.bundle[var_name4]
            local song5 = params.bundle[var_name5]
            local song6 = params.bundle[var_name6]
            local sn = spell_name
            if sn == "--bundle" then
                sn = params.bundle[var_name]
            end
            local buff = gd.buffs[sn]
            local _, spell = get_highest_tier_buff(player, buff, (target == player.self.name), true)
            local pms = params

            pms.bundle['spell'] = {}
            pms.bundle.spell.name = spell.name
            pms.bundle.spell.id = spell.id
            pms.bundle.spell.prefix = spell.prefix

            return true, pms
        end)
    }
    return obj
end

M.cond = cond

return M