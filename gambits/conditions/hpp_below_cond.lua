local M = {}

function hpp_below_cond(hpp_threshold)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player)
            return player.instance.vitals.hpp <= hpp_threshold
        end)
    }
    return obj
end

M.hpp_below_cond = hpp_below_cond

return M