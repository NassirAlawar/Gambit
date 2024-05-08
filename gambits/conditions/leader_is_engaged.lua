local M = {}

local gd = require('gambits/gambit_defines')

function cond(leader)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local name = leader
            if type(name) == 'function' then
                name = name()
            end
            name = (name:gsub("^%l", string.upper))

            local lmob = windower.ffxi.get_mob_by_name(name)
            local ltarget = windower.ffxi.get_mob_by_index(lmob.target_index)
            -- lmob['status'] == 1 is: leader is engaged
            -- ltarget['claim_id'] ~= 0: the leaders target is claimed
            return lmob['status'] == 1 and ltarget ~= nil and ltarget['claim_id'] ~= 0, params
        end)
    }
    return obj
end

M.cond = cond

return M