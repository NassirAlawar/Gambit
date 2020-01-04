local M = {}

function chat_match_cond(text, required_speaker)
    text = text:lower()
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if params == nil then return false end
            if params.chatStr == nil then return false end
            local str = params.chatStr:lower()
            local speaker, speech = string.match(str, "%((%a+)%) (.*)")
            if required_speaker ~= nil then
                if speaker ~= nil then return false end
                if speaker ~= required_speaker then return false end
                return (speech == text)
            else
                if speech == nil then return false end
                return (speech == text)
            end
        end)
    }
    return obj
end

M.chat_match_cond = chat_match_cond

return M