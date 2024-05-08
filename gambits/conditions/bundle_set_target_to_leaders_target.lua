local M = {}

local gd = require('gambits/gambit_defines')

function cond(target_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local pms = params
            local target_by_id = false
            local target_id = nil
            local target_index = nil
            local target = nil

            local success = false

            local spell = res.spells:with('id', pms.bundle.spell.id)

            -- If needs to be cast on a monster
            if spell.targets['Enemy'] ~= nil then
                local mob = windower.ffxi.get_mob_by_name(target_name)
                if mob ~= nil then
                    target_index = mob['target_index']
                    if target_index ~= nil then
                        local targ = windower.ffxi.get_mob_by_index(target_index)
                        if targ ~= nil then
                            -- If target is a monster
                            if targ.is_npc then
                                target = targ.name
                                target_id = targ.id
                                target_by_id = true
                                success = true
                            end
                        end
                    end
                end
            end

            pms.bundle.spell.target_by_id = target_by_id
            pms.bundle.spell.target_id = target_id
            pms.bundle.spell.target_index = target_index
            pms.bundle.spell.target = target

            return success, pms
        end)
    }
    return obj
end

M.cond = cond

return M