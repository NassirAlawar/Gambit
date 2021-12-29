local M = {}

function cond(buff_name)
    buff_name = buff_name:lower()
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            return player.buffs[buff_name] == nil or (not (player.buffs[buff_name] > 0)), params
        end)
    }
    return obj
end

M.cond = cond

return M