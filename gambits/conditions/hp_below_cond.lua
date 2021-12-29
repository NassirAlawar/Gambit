local M = {}

function cond(hp_threshold)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            return player.instance.vitals.hp <= hp_threshold, params
        end)
    }
    return obj
end

M.cond = cond

return M