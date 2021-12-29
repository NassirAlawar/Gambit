gd = require('gambits/gambit_defines')
local M = {}
chat_match_cond = require('gambits/conditions/chat_match_cond')

function cond(text, action, target)
    local condition = chat_match_cond.chat_match_cond(text)
    local obj = {
        trigger_type = gd.trigger_types.chat,
        proc = (function()
            action()
            return true
        end),
        initalize_gambit = (function()
            condition.initalize_condition()
        end),
        should_proc = (function(player, str)
            return condition.should_proc(player, str)
        end)
    }
    return obj
end

M.cond = cond

return M