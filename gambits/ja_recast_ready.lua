gd = require('gambits/gambit_defines')
local M = {}

function cond(ability_name, action, target)
    local obj = {
        trigger_type = gd.trigger_types.trigger,
        proc = (function()
            action()
            return true
        end),
        initalize_gambit = (function()
        end),
        should_proc = (function(player)
            local abil = res.job_abilities:with('name', ability_name)
            return player.ja_recasts[abil.recast_id] == 0
        end)
    }
    return obj
end

M.cond = cond

return M