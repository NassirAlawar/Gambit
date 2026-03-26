local M = {}

local gd = require('gambits/gambit_defines')

function cond(leader, target_name)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if target_name == nil then return false, params end

            local name = leader
            if type(name) == 'function' then
                name = name()
            end
            name = (name:gsub("^%l", string.upper))

            local lmob = windower.ffxi.get_mob_by_name(name)
            if lmob == nil then
                return false, params
            end
            local ltarget = windower.ffxi.get_mob_by_index(lmob.target_index)
            if ltarget == nil then
                return false, params
            end
            if type(target_name) == 'string' then
                return string.lower(ltarget['name']) == string.lower(target_name), params
            else
                return target_name:contains(ltarget['name']), params
            end
        end)
    }
    return obj
end

M.cond = cond

return M