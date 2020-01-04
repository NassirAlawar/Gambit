local M = {}

statuses = require('res/statuses')

function can_cast_spell_cond(spell_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if spell_name == "--bundle" then
                spell_name = params.bundle.spell.name:gsub("^%l", string.upper)
            end
            
            local spell = res.spells:with('name', spell_name)
            local main_job_id = player.instance.main_job_id
            local main_job_level = player.instance.main_job_level
            local sub_job_id = player.instance.sub_job_id
            local sub_job_level = player.instance.sub_job_level
            local status = statuses[player.instance.status]
            
            local good_to_go = true
            good_to_go = good_to_go and (player.ma_recasts[spell.id] == 0)
            good_to_go = good_to_go and ((spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= main_job_level) or (spell.levels[sub_job_id] ~= nil and spell.levels[sub_job_id] <= sub_job_level))
            good_to_go = good_to_go and (player.instance.vitals.mp >= spell.mp_cost)
            
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
            
            return good_to_go, params
        end)
    }
    return obj
end

M.can_cast_spell_cond = can_cast_spell_cond

return M