gd = require('gambits/gambit_defines')
local M = {}
chat_match_cond = require('gambits/conditions/chat_match_cond')

function chat_trigger(text, action, target)
    local cond = chat_match_cond.chat_match_cond(text)
    local obj = {
        trigger_type = gd.trigger_types.chat,
        proc = (function()
            action()
            return true
        end),
        initalize_gambit = (function()
            cond.initalize_condition()
        end),
        should_proc = (function(player, str)
            return cond.should_proc(player, str)
        end)
    }
    return obj
end

M.chat_trigger = chat_trigger

return M