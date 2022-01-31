local M = {}

function cond(index, bundle_key, required_speaker)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if bundle_key == nil then return false, params end
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
            if part ~= nil then
                params.bundle[bundle_key] = part
            end
            return part ~= nil, params
        end)
    }
    return obj
end

M.cond = cond

return M