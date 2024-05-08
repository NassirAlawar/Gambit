gd = require('gambits/gambit_defines')
local M = {}

function cond(conditions, action, target)
    local obj = {
        trigger_type = gd.trigger_types.trigger,
        proc = (function(player, params)
            action(player, params)
            return true
        end),
        initalize_gambit = (function()
            for i, condition in ipairs(conditions) do
                condition.initalize_condition()
            end
        end),
        should_proc = (function(player, params)
            local good_to_go = true
            local pms = params
            for i, condition in ipairs(conditions) do
                local sp, pm = condition.should_proc(player, pms)
                pms = pm
                good_to_go = good_to_go and sp 
                if not good_to_go then
                    break
                end
            end
            return good_to_go, pms
        end),
        after_proc = (function(player, params)
            local pms = params
            for i, condition in ipairs(conditions) do
                if condition.after_proc ~= nil then
                    pms = condition.after_proc(player, pms)
                end
            end
            return pms
        end)
    }
    return obj
end

M.cond = cond

return M