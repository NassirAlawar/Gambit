local M = {}

local gd = require('gambits/gambit_defines')

function cond(target, var_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local trg = target
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
            end
            local pms = params
            if trg == nil then return false, pms end
            pms.bundle.spell.target = trg
            return true, pms
        end)
    }
    return obj
end

M.cond = cond

return M