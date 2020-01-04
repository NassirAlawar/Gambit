gd = require('gambits/gambit_defines')
local M = {}

function multi_condition_trigger(conditions, action, target)
    local obj = {
        trigger_type = gd.trigger_types.trigger,
        proc = (function(player, params)
            action(player, params)
            return true
        end),
        initalize_gambit = (function()
            for i, cond in ipairs(conditions) do
                cond.initalize_condition()
            end
        end),
        should_proc = (function(player, params)
            local good_to_go = true
            local pms = params
            for i, cond in ipairs(conditions) do
                local sp, pm = cond.should_proc(player, pms)
                pms = pm
                good_to_go = good_to_go and sp 
                if not good_to_go then
                    break
                end
            end
            return good_to_go, pms
        end)
    }
    return obj
end

M.multi_condition_trigger = multi_condition_trigger

return M