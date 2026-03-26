local M = {}

function cond(target_name, buff_name, number)
    buff_name = buff_name:lower()
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local party_id = get_party_member_key_by_name(target_name)
            if party_id ~= nil then
                local party_info = player.party[party_id]
                if party_info ~= nil then
                    local mob = party_info.mob
                    if mob ~= nil then
                        local buffs = player.party_buffs[mob.index]
                        if buffs ~= nil then
                            return buffs[buff_name:lower()] == nil or (not (buffs[buff_name:lower()] >= number)), params
                        end
                    end
                end
            end
            return false, params
        end)
    }
    return obj
end

M.cond = cond

return M