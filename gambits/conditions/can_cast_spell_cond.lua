local M = {}

statuses = require('res/statuses')

-- Taken from Gearswap
-- Lookup table to convert the distance in resouces to the distance in yalms
spell_distances = {
    [2] = 4*4,
    [3] = 5*5,
    [4] = 6.2*6.2,
    [5] = 7.5*7.5,
    [6] = 7.8*7.8,
    [7] = 8.8*8.8,
    [8] = 11*11,
    [9] = 13*13,
   [10] = 15*15,
   [11] = 16.6*16.6,
   [12] = 21*21,
}

function cond(spell_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local name = spell_name
            if name == "--bundle" then
                name = params.bundle.spell.name:gsub("^%l", string.upper)
            end
            
            local spell = res.spells:with('name', name)
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

            if good_to_go and spell.range > 0 and spell_name == "--bundle" then
                local mob = nil
                if params.bundle.spell.target_by_id then
                    mob = windower.ffxi.get_mob_by_index(params.bundle.spell.target_index)
                else
                    mob = windower.ffxi.get_mob_by_name(params.bundle.spell.target)
                end
                good_to_go = good_to_go and (mob ~= nil and spell_distances[spell.range] ~= nil and mob.distance < spell_distances[spell.range])
            end
            
            return good_to_go, params
        end)
    }
    return obj
end

M.cond = cond

return M