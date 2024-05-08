local M = {}

local gd = require('gambits/gambit_defines')

function cond(target_name, max_distance, useTargetOfTarget)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if player.pet == nil then
                return false, params
            end

            local name = target_name
            if type(name) == 'function' then
                name = name()
            end
            name = (name:gsub("^%l", string.upper))
            
            local target = windower.ffxi.get_mob_by_name(name)
            if target == nil then
                return false, params
            end

            if useTargetOfTarget then
                target = windower.ffxi.get_mob_by_index(target.target_index)
                if target == nil then
                    return false, params
                end
            end

            local tDis = math.sqrt(((target.x - player.pet.x) * (target.x - player.pet.x)) + ((target.y - player.pet.y) * (target.y - player.pet.y)))
            if tDis < max_distance then
                return true, params
            end
            return false, params
        end)
    }
    return obj
end

M.cond = cond

return M