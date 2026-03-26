local M = {}

local gd = require('gambits/gambit_defines')

local element_map = {
    fire = "Ignis",
    ice = "Gelus",
    wind = "Flabra",
    earth = "Tellus",
    thunder = "Sulpor",
    water = "Unda",
    light = "Lux",
    dark = "Tenebrae"
}

function cond(element, var_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local e = element
            if e == "--global" then
                e = get_global_condition(var_name)()
            end
			
			e = e:lower()
            
            local rune = element_map[e]
            if rune == nil then
                return false, params
            end

            local spell = res.job_abilities:with('english', rune)
            
			local pms = params
            if pms.bundle == nil then pms.bundle = {} end
            if pms.bundle.spell == nil then pms.bundle.spell = {} end
            
            pms.bundle.spell.name = spell.name
            pms.bundle.spell.id = spell.id
            pms.bundle.spell.prefix = spell.prefix
            pms.bundle.spell.target = "me"

            return true, pms
        end)
    }
    return obj
end

M.cond = cond

return M