local M = {}

function cond(text, index, required_speaker)
    text = text:lower()
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if params == nil then return false, params end
            if params.chatStr == nil then return false, params end
            local str = params.chatStr:lower()
            local speaker, speech = string.match(str, "%((%a+)%) (.*)")
            local count = 0
            local part = nil
            for p in string.gmatch(speech, "[^%s]+") do
                if count == index then
                    part = p:gsub("%s+", "")
                    break
                end
                count = count + 1
            end
            if required_speaker ~= nil then
                if speaker == nil then return false, params end
                
                local name = required_speaker
                if type(name) == 'function' then
                    name = name()
                end

                if speaker:lower() ~= name:lower() then return false, params end
                return (part == text), params
            else
                if part == nil then return false, params end
                return (part == text), params
            end
        end)
    }
    return obj
end

M.cond = cond

return M