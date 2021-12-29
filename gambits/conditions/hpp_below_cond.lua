local M = {}

function cond(hpp_threshold)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            return player.instance.vitals.hpp <= hpp_threshold, params
        end)
    }
    return obj
end

M.cond = cond

return M