local M = {}

local gd = require('gambits/gambit_defines')

function cond(leader)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local lmob = windower.ffxi.get_mob_by_name(leader)
            local ltarget = windower.ffxi.get_mob_by_index(lmob.target_index)
            -- lmob['status'] == 1 is: leader is engaged
            -- ltarget['claim_id'] ~= 0: the leaders target is claimed
            return lmob['status'] == 1 and ltarget['claim_id'] ~= 0, params
        end)
    }
    return obj
end

M.cond = cond

return M