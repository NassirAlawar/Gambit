local M = {}

function cond(tp_threshold)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            return player.instance.vitals.tp >= tp_threshold, params
        end)
    }
    return obj
end

M.cond = cond

return M