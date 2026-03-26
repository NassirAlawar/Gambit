local M = {}

local gd = require('gambits/gambit_defines')

function cond(target_name, not_in_list)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            if target_name == nil then return false, params end
            local ltarget = windower.ffxi.get_mob_by_target("t")
            if ltarget == nil then
                return false, params
            end
            local result = false
            if type(target_name) == 'string' then
                 result = string.lower(ltarget['name']) == string.lower(target_name)
            else
                result = target_name:contains(ltarget['name'])
            end
            if not_in_list then
                result = not result
            end
            return result, params
        end)
    }
    return obj
end

M.cond = cond

return M