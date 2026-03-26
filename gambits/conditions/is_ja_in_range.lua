local M = {}

gd = require('gambits/gambit_defines')

function cond(ability_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local abil = res.job_abilities:with('name', ability_name)
            local target_mob = windower.ffxi.get_mob_by_target("t")
            local is_valid = false
            if target_mob ~= nil and abil ~= nil then
                local me = windower.ffxi.get_player()
                local dist = distance(target_mob.x, target_mob.y, me.x, me.y)
                if dist <= abil.range
            end
            return player.ja_recasts[abil.recast_id] == 0, params
        end)
    }
    return obj
end

M.cond = cond

return M