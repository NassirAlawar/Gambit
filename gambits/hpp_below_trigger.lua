gd = require('gambits/gambit_defines')
local M = {}
hpp_cond = require('gambits/conditions/hpp_below_cond')

function hpp_below_trigger(hpp, action, target)
    local cond = hpp_cond.hpp_below_cond(hpp)
    local obj = {
        trigger_type = gd.trigger_types.trigger,
        proc = (function()
            action()
            return true
        end),
        initalize_gambit = (function()
            cond.initalize_condition()
        end),
        should_proc = (function(player)
            return cond.should_proc(player)
        end)
    }
    return obj
end

M.hpp_below_trigger = hpp_below_trigger

return M