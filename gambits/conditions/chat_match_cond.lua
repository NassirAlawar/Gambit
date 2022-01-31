local M = {}

function cond(text, required_speaker)
    text = text:lower()
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if params == nil then return false, params end
            if params.chatStr == nil then return false, params end
            local str = params.chatStr:lower()
            local speaker, speech = string.match(str, "%((%a+)%) (.*)")
            if required_speaker ~= nil then
                if speaker == nil then return false, params end
                if speaker:lower() ~= required_speaker:lower() then return false, params end
                return (speech == text), params
            else
                if speech == nil then return false, params end
                return (speech == text), params
            end
        end)
    }
    return obj
end

M.cond = cond

return M