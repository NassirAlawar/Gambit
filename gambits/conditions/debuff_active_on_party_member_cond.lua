local M = {}

local l_funcs = {}
l_funcs.get_highest_tier_buff = function (player, buff)
    local main_job_id = player.instance.main_job_id
    local main_job_level = player.instance.main_job_level
    local sub_job_id = player.instance.sub_job_id
    local sub_job_level = player.instance.sub_job_level
    local job_points = player.instance.job_points[res.jobs[main_job_id].ens:lower()].jp_spent
    local highest = nil
    local spell = nil

    for i, b in ipairs(buff) do
        spell = res.spells:with('name', b)
        if spell ~= nil and player.spells[spell.id] then
            if ((spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= main_job_level) or (spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= job_points) or (spell.levels[sub_job_id] ~= nil and spell.levels[sub_job_id] <= sub_job_level)) then
                highest = b
                break
            end
        end
    end

    return highest, spell
end

function cond(debuffs)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            for k, v in pairs(player.party) do
                if type(v) == 'table' then
                    local mob = v.mob
                    if mob ~= nil then
                        local buffs = player.party_buffs[mob.index]
                        if buffs ~= nil then
                            for kk, vv in pairs(debuffs) do
                                if type(kk) == 'string' then
                                    local debuff = kk:lower()
                                    if buffs[debuff] ~= nil and ((buffs[debuff] > 0)) then
                                        local pms = params
                                        if pms.bundle == nil then pms.bundle = {} end
                                        if pms.bundle.spell == nil then pms.bundle.spell = {} end
                                        
                                        local name, spell = l_funcs.get_highest_tier_buff(player, gd.heals[debuff])
        
                                        pms.bundle.spell.name = name
                                        pms.bundle.spell.id = spell.id
                                        pms.bundle.spell.prefix = spell.prefix
                                        pms.bundle.spell.target_by_id = true
                                        pms.bundle.spell.target_id = v.mob.id
                                        pms.bundle.spell.target_index = v.mob.index
                                        pms.bundle.spell.target = mob.name
                                        return pms.bundle.spell.name ~= nil, pms
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