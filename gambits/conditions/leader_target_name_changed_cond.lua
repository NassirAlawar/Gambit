local M = {}

local gd = require('gambits/gambit_defines')

function cond(leader, uuid)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if params.g_bundle[uuid] == nil then
                params.g_bundle[uuid] = {}
            end
            local last_target_name = params.g_bundle[uuid].last_target_name

            local name = leader
            if type(name) == 'function' then
                name = name()
            end
            name = (name:gsub("^%l", string.upper))

            local mob = windower.ffxi.get_mob_by_name(name)
            if mob == nil then
                return false, params
            end
            local target = windower.ffxi.get_mob_by_index(mob.target_index)
            local current_target_name = target.name
            return last_target_name ~= current_target_name, params
        end),
        after_proc = (function(player, params)
            
            local name = leader
            if type(name) == 'function' then
                name = name()
            end
            name = (name:gsub("^%l", string.upper))

            local mob = windower.ffxi.get_mob_by_name(name)
            local target = windower.ffxi.get_mob_by_index(mob.target_index)
            local current_target_name = target.name
            params.g_bundle[uuid].last_target_name = current_target_name
            return params
        end)
    }
    return obj
end

M.cond = cond

return M