local M = {}

function mpp_below_cond(mpp_threshold)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player)
            return player.instance.vitals.mpp <= mpp_threshold
        end)
    }
    return obj
end

M.mpp_below_cond = mpp_below_cond

return M