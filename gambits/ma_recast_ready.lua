res = require('resources')
gd = require('gambits/gambit_defines')
local M = {}

function cond(spell_name, action, target)
    local obj = {
        trigger_type = gd.trigger_types.trigger,
        proc = (function()
            action()
            return true
        end),
        initalize_gambit = (function()
        end),
        should_proc = (function(player)
            local spell = res.spells:with('name', spell_name)
            return player.ma_recasts[spell.id] == 0
        end)
    }
    return obj
end

M.cond = cond

return M