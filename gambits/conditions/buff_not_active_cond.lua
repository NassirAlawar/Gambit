local M = {}

function cond(buff_name, number)
    buff_name = buff_name:lower()
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local name = buff_name
            if name == "--bundle" then
                name = params.bundle.spell.name:lower()
            end
            return player.buffs[name] == nil or (player.buffs[name] < number), params
        end)
    }
    return obj
end

M.cond = cond

return M