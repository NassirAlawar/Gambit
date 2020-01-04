gd = require('gambits/gambit_defines')
local M = {}
hp_cond = require('gambits/conditions/hp_below_cond')

function hp_below_trigger(hp, action, target)
    local cond = hp_cond.hp_below_cond(hp)
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

M.hp_below_trigger = hp_below_trigger

return M