local M = {}

function tp_below_cond(tp_threshold)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player)
            return player.instance.vitals.tp <= tp_threshold
        end)
    }
    return obj
end

M.tp_below_cond = tp_below_cond

return M