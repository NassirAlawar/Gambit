local M = {}

function cond(mp_threshold)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            return player.instance.vitals.mp <= mp_threshold, params
        end)
    }
    return obj
end

M.cond = cond

return M