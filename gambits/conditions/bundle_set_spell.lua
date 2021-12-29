local M = {}

local gd = require('gambits/gambit_defines')

function cond(spell_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local spell = res.spells:with('name', spell_name)
            local pms = params

            pms.bundle['spell'] = {}
            pms.bundle.spell.name = spell_name
            pms.bundle.spell.id = spell.id
            pms.bundle.spell.prefix = spell.prefix

            return true, pms
        end)
    }
    return obj
end

M.cond = cond

return M