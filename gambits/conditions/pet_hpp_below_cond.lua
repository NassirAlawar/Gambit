local M = {}

local gd = require('gambits/gambit_defines')

function cond(hpp)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if player.pet == nil then
                return false, params
            end
            return player.pet.hpp < hpp, params
        end)
    }
    return obj
end

M.cond = cond

return M