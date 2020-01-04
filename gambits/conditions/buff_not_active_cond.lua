local M = {}

function buff_not_active_cond(buff_name)
    buff_name = buff_name:lower()
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player)
            return player.buffs[buff_name] == nil or (not (player.buffs[buff_name] > 0))
        end)
    }
    return obj
end

M.buff_not_active_cond = buff_not_active_cond

return M