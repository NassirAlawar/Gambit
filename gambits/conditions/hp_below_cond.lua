local M = {}

function hp_below_cond(hp_threshold)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player)
            return player.instance.vitals.hp <= hp_threshold
        end)
    }
    return obj
end

M.hp_below_cond = hp_below_cond

return M