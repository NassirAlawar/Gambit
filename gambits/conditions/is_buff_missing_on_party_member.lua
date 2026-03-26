local M = {}

function cond(members, buff_name)
    buff_name = buff_name:lower()
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            for k, party_info in pairs(player.party) do
                if type(party_info) == 'table' then
                    if party_info ~= nil then
                        if members:contains(party_info.name) then
                            local mob = party_info.mob
                            if mob ~= nil and mob.hpp > 0 then
                                local buffs = player.party_buffs[mob.index]
                                if buffs ~= nil then
                                    if buffs[buff_name:lower()] == nil then
                                        local pms = params
                                        if pms.bundle == nil then pms.bundle = {} end
                                        if pms.bundle.spell == nil then pms.bundle.spell = {} end
                                        pms.bundle.spell.target_by_id = true
                                        pms.bundle.spell.target_id = mob.id
                                        pms.bundle.spell.target_index = mob.index
                                        pms.bundle.spell.target = mob.name
                                        return buffs[buff_name:lower()] == nil, pms
                                    end
                                end
                            end
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