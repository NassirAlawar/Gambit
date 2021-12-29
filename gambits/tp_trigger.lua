gd = require('gambits/gambit_defines')
local M = {}
tp_cond = require('gambits/conditions/tp_above_cond')

function cond(tp, action, target)
    local condition = tp_cond.tp_above_cond(tp)
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