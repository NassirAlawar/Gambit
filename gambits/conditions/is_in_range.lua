local M = {}

gd = require('gambits/gambit_defines')

function cond(skill_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local skill = res.job_abilities:with('name', skill_name)
            if skill == nil then
                skill = res.weapon_skills:with('en', skill_name)
            end
            if skill == nil then
                skill = res.spells:with('en', skill_name)
            end
            if skill == nil then
                return false, params
            end

            local target_mob = windower.ffxi.get_mob_by_target("t")
            if target_mob ~= nil then
                local dist = distance(target_mob.x, target_mob.y, player.self.x, player.self.y)
                local range = range_to_distance(skill.range)
                return dist < range, params
            end
            return false, params
        end)
    }
    return obj
end

M.cond = cond

return M