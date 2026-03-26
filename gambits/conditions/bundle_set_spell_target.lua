local M = {}

local gd = require('gambits/gambit_defines')

function cond(target, var_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local trg = target
            local target_by_id = false
            local target_id = 0
            local target_index = 0
            if trg == "--global" then
                trg = get_global_condition(var_name)()
                if trg == nil or trg == "" then
                    trg = "me"
                end
            elseif trg == "--bundle" then
                trg = params.bundle[var_name]
                if trg == nil or trg == "" then
                    trg = "me"
                end
            elseif trg == "t" then
                local mob = windower.ffxi.get_mob_by_target('t')
                if mob ~= nil then
                    target_by_id = true
                    target_id = mob.id
                    target_index = mob.index
                end
            end
            local pms = params
            if trg == nil then return false, pms end
            pms.bundle.spell.target = trg
            pms.bundle.spell.target_by_id = target_by_id
            pms.bundle.spell.target_id = target_id
            pms.bundle.spell.target_index = target_index
            return true, pms
        end)
    }
    return obj
end

M.cond = cond

return M