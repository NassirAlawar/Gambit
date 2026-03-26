local M = {}

function cond(weapon_name)
    weapon_name = weapon_name:lower()
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local equipment = windower.ffxi.get_items().equipment
            local main_slot = equipment.main
            local main_bag = equipment.main_bag
            if main_slot == 0 then
                return false, params
            end
            local item = windower.ffxi.get_items(main_bag)[main_slot]
            if item == nil or item.id == 0 then
                return false, params
            end
            local item_info = res.items[item.id]
            if item_info == nil then
                return false, params
            end
            return item_info.en:lower() == weapon_name, params
        end)
    }
    return obj
end

M.cond = cond

return M
