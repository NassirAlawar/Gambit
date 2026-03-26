local M = {}

gd = require('gambits/gambit_defines')

function cond(ability_name, target)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local name = ability_name
            if name == "--bundle" then
                name = params.bundle.spell.name
            end
            local abil = res.job_abilities:with('name', name)
            return player.ja_recasts[abil.recast_id] == 0, params
        end)
    }
    return obj
end

M.cond = cond

return M