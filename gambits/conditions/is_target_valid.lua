local M = {}

statuses = require('res/statuses')
require('tables')

-- Taken from Gearswap
-- Lookup table to convert the distance in resouces to the distance in yalms
spell_distances = {
    [2] = 4*4,
    [3] = 5*5,
    [4] = 6.2*6.2,
    [5] = 7.5*7.5,
    [6] = 7.8*7.8,
    [7] = 8.8*8.8,
    [8] = 11*11,
    [9] = 13*13,
   [10] = 15*15,
   [11] = 16.6*16.6,
   [12] = 21*21,
}

function cond(target, spell_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local name = spell_name
            if name == "--bundle" then
                name = params.bundle.spell.name:gsub("^%l", string.upper)
            end

            local spell = res.spells:with('name', name)
            
            local good_to_go = true
            if good_to_go and spell.range > 0 and spell_name == "--bundle" then
                local mob = nil
                if params.bundle.spell.target_by_id then
                    mob = windower.ffxi.get_mob_by_index(params.bundle.spell.target_index)
                else
                    local mob_name = params.bundle.spell.target:gsub("^%l", string.upper)
                    mob = windower.ffxi.get_mob_by_name(mob_name)
                end
                good_to_go = good_to_go and (mob ~= nil and spell_distances[spell.range] ~= nil and mob.distance < spell_distances[spell.range])
            end
            return good_to_go, params
        end)
    }
    return obj
end

M.cond = cond

return M