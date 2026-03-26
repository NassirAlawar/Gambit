local M = {}

local gd = require('gambits/gambit_defines')

function cond(uuid)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if params.g_bundle[uuid] == nil then
                params.g_bundle[uuid] = {}
            end
            local last_target_name = params.g_bundle[uuid].last_target_name

            local target = windower.ffxi.get_mob_by_target("t")
            local current_target_name = target.name
            return last_target_name ~= current_target_name, params
        end),
        after_proc = (function(player, params)
            local target = windower.ffxi.get_mob_by_target("t")
            local current_target_name = target.name
            params.g_bundle[uuid].last_target_name = current_target_name
            return params
        end)
    }
    return obj
end

M.cond = cond

return M