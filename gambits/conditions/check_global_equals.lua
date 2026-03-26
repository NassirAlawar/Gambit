local M = {}

local gd = require('gambits/gambit_defines')

function cond(variable_name, value, invert)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if invert then
                return params.g_bundle.conditions[variable_name] ~= value, params
            else
                return params.g_bundle.conditions[variable_name] == value, params
            end
        end)
    }
    return obj
end

M.cond = cond

return M