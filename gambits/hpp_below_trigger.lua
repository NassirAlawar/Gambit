gd = require('gambits/gambit_defines')
local M = {}
hpp_cond = require('gambits/conditions/hpp_below_cond')

function cond(hpp, action, target)
    local condition = hpp_cond.hpp_below_cond(hpp)
    local obj = {
        trigger_type = gd.trigger_types.trigger,
        proc = (function()
            action()
            return true
        end),
        initalize_gambit = (function()
            condition.initalize_condition()
        end),
        should_proc = (function(player)
            return condition.should_proc(player)
        end)
    }
    return obj
end

M.cond = cond

return M