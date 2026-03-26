local M = {}

gd = require('gambits/gambit_defines')

function cond(spell_name, target)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local spell = res.spells:with('name', spell_name)
            return player.ma_recasts[spell.id] == 0, params
        end)
    }
    return obj
end

M.cond = cond

return M