local M = {}

local gd = require('gambits/gambit_defines')

function cond(spell_name, var_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local sn = spell_name
            if sn == "--global" then
                sn = get_global_condition(var_name)()
            end
            
            local spell = res.spells:with('name', sn)
            local pms = params

            pms.bundle['spell'] = {}
            pms.bundle.spell.name = spell.name
            pms.bundle.spell.id = spell.id
            pms.bundle.spell.prefix = spell.prefix

            return true, pms
        end)
    }
    return obj
end

M.cond = cond

return M