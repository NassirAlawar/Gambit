gd = require('gambits/gambit_defines')
local M = {}
hp_cond = require('gambits/conditions/hp_below_cond')

function cond(hp, action, target)
    local condition = hp_cond.hp_below_cond(hp)
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