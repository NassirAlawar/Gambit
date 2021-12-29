local M = {}

function cond(mpp_threshold)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            return player.instance.vitals.mpp <= mpp_threshold, params
        end)
    }
    return obj
end

M.cond = cond

return M