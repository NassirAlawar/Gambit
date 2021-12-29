local M = {}

local gd = require('gambits/gambit_defines')

function cond(variable_name, value)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            return params.g_bundle.conditions[variable_name] == value, params
        end)
    }
    return obj
end

M.cond = cond

return M