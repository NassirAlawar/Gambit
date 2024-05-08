local M = {}

local gd = require('gambits/gambit_defines')

function cond(uuid)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if params.g_bundle[uuid] == nil then
                params.g_bundle[uuid] = {}
            end
            local last_target_index = params.g_bundle[uuid].last_target_index

            local lmob = windower.ffxi.get_player()
            local ltarget = windower.ffxi.get_mob_by_target("t")
            -- lmob['status'] == 1 is: leader is engaged
            -- ltarget['claim_id'] ~= 0: the leaders target is claimed
            local current_target_index = lmob.target_index
            
            return lmob['status'] == 1 and ltarget ~= nil and ltarget['claim_id'] ~= 0 and last_target_index ~= current_target_index, params
        end),
        after_proc = (function(player, params)
            local mob = windower.ffxi.get_player()
            local current_target_index = mob.target_index
            params.g_bundle[uuid].last_target_index = current_target_index
            return params
        end)
    }
    return obj
end

M.cond = cond

return M