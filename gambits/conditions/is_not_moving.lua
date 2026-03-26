local M = {}

local gd = require('gambits/gambit_defines')

function cond()
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if params.g_bundle["0d92492e-86ee-4a19-bbfc-bccd443f1824"] == nil then
                params.g_bundle["0d92492e-86ee-4a19-bbfc-bccd443f1824"] = {}
            end
            local last_x = params.g_bundle["0d92492e-86ee-4a19-bbfc-bccd443f1824"].last_x
            local last_y = params.g_bundle["0d92492e-86ee-4a19-bbfc-bccd443f1824"].last_y

            local mob = windower.ffxi.get_mob_by_target("me")
            if mob == nil then
                return false, params
            end
            params.g_bundle["0d92492e-86ee-4a19-bbfc-bccd443f1824"].last_x = mob.x
            params.g_bundle["0d92492e-86ee-4a19-bbfc-bccd443f1824"].last_y = mob.y
            return last_x == mob.x and last_y == mob.y, params
        end)
    }
    return obj
end

M.cond = cond

return M
