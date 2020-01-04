local M = {}

function mp_below_cond(mp_threshold)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player)
            return player.instance.vitals.mp <= mp_threshold
        end)
    }
    return obj
end

M.mp_below_cond = mp_below_cond

return M