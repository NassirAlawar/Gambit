local M = {}

local gd = require('gambits/gambit_defines')

function cond(hpp)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local target = windower.ffxi.get_mob_by_target("t")
            return target ~= nil and target['hpp'] < hpp, params
        end)
    }
    return obj
end

M.cond = cond

return M