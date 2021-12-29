local M = {}

local gd = require('gambits/gambit_defines')

function cond(target_name, max_distance)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            return player.pet ~= nil, params
        end)
    }
    return obj
end

M.cond = cond

return M