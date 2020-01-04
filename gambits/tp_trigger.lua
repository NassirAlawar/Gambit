gd = require('gambits/gambit_defines')
local M = {}
tp_cond = require('gambits/conditions/tp_above_cond')

function tp_trigger(tp, action, target)
    local cond = tp_cond.tp_above_cond(tp)
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

M.tp_trigger = tp_trigger

return M