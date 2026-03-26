gd = require('gambits/gambit_defines')

local M = {}

List = Q{}

curaga_priority = false

cure_values = {}
cure_values["Cure"] = 188
cure_values["Cure II"] = 270
cure_values["Cure III"] = 533
cure_values["Cure IV"] = 974
cure_values["Cure V"] = 1298
cure_values["Cure VI"] = 1577

cure_values["Curaga"] = 246
cure_values["Curaga II"] = 357
cure_values["Curaga III"] = 695
cure_values["Curaga IV"] = 1224
cure_values["Curaga V"] = 1879

cure_values["Cura"] = 92
cure_values["Cura II"] = 188
cure_values["Cura III"] = 298

local l_funcs = {}
l_funcs.get_highest_tier_cure = function (player, spellset, missing_hp)
    local main_job_id = player.instance.main_job_id
    local main_job_level = player.instance.main_job_level
    local sub_job_id = player.instance.sub_job_id
    local sub_job_level = player.instance.sub_job_level
    local mp = player.instance.vitals.mp
    local name = nil
    local spell = nil
    local highest_spell = nil

    for i, s in ipairs(spellset) do
        spell = res.spells:with('name', s)
        if spell ~= nil and player.spells[spell.id] then
            if mp >= spell.mp_cost and player.ma_recasts[spell.id] == 0 and ((spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= main_job_level) or (spell.levels[sub_job_id] ~= nil and spell.levels[sub_job_id] <= sub_job_level)) then
                if name == nil then
                    name = s
                    highest_spell = spell
                elseif cure_values[s] ~= nil and cure_values[s] > missing_hp then
                    name = s
                    highest_spell = spell
                end
            end
        end
    end

    return name, highest_spell
end

function cond()
    local party_info = {}
    local obj = {
        trigger_type = gd.trigger_types.trigger,
        proc = (function(player, params)
            -- Handle AoE critical
            -- Handle single critical
            -- Handle AoE
            -- Handle single
            local best_target = nil
            local best_spell = nil
            local best_critical_aoe_info = nil
            local best_aoe_info = nil
            local best_single = nil
            
            -- process critical AoE cures
            for k, v in pairs(player.party) do
                if type(v) == 'table' then
                    local current = party_info[v.name]
                    if current ~= nil then
                        current.name = v.name
                        -- Someone is critical in this aoe group
                        if not current.is_alliance_member and current.curaga_num_in_range_critical_percent > 0 then
                            if best_critical_aoe_info == nil or best_critical_aoe_info.curaga_num_in_range_critical_percent <= current.curaga_num_in_range_critical_percent then
                                if best_critical_aoe_info == nil then
                                    best_critical_aoe_info = current
                                elseif best_critical_aoe_info.curaga_num_in_range_critical_percent == current.curaga_num_in_range_critical_percent then
                                    if best_critical_aoe_info.curaga_potential_hp < current.curaga_potential_hp then
                                        best_critical_aoe_info = current
                                    end
                                else
                                    best_critical_aoe_info = current
                                end
                            end
                        end

                        -- standard AoE
                        if not current.is_alliance_member and current.curaga_num_in_range_under_cure_percent > 0 then
                            if best_aoe_info == nil or best_aoe_info.curaga_num_in_range_under_cure_percent <= current.curaga_num_in_range_under_cure_percent then
                                if best_aoe_info == nil then
                                    best_aoe_info = current
                                elseif best_aoe_info.curaga_num_in_range_under_cure_percent == current.curaga_num_in_range_under_cure_percent then
                                    if best_aoe_info.curaga_potential_hp < current.curaga_potential_hp then
                                        best_aoe_info = current
                                    end
                                else
                                    best_aoe_info = current
                                end
                            end
                        end

                        -- single target
                        if current.is_under_cure_precent then
                            if best_single == nil then
                                best_single = current
                            elseif current.is_critical and not best_single.is_critical then
                                best_single = current
                            elseif current.hp < best_single.hp then
                                best_single = current
                            end
                        end
                    end
                end
            end

            
            local should_aoe = false
            local curaga_most_missing_hp = 0
            local multi_critical = false

            local highest_curaga = 0
            local highest_cure = 0
            local highest_cura = 0
            local player_mp = player.instance.vitals.mp

            -- If MP is less than 80 and we are doing single target then do Full Cure
            -- This means replace cure 3 with full cure

            if player_mp == 0 then 
                return false
            end

            local main_job = res.jobs[player.instance.main_job_id]
            local sub_job = res.jobs[player.instance.sub_job_id]

            local can_curaga = main_job.ens == "WHM" or sub_job.ens == "WHM"

            -- if we have at least 1 in critical and more than 1 under the cure % then AoE
            if can_curaga and best_critical_aoe_info ~= nil and best_critical_aoe_info.curaga_num_in_range_critical_percent >= 1 and best_critical_aoe_info.curaga_num_in_range_under_cure_percent > 1 then
                best_target = best_critical_aoe_info.name
                should_aoe = true
                if best_critical_aoe_info.curaga_num_in_range_critical_percent > 1 then
                    multi_critical = true
                end
                curaga_most_missing_hp = best_critical_aoe_info.curaga_most_missing_hp
            -- process single critical cures only if we have 1 critical target and no other people that are below cure %
            elseif best_single ~= nil and best_single.is_critical then
                best_target = best_single.name
            elseif can_curaga and best_aoe_info ~= nil and best_aoe_info.curaga_num_in_range_under_cure_percent > 1 then
                best_target = best_aoe_info.name
                should_aoe = true
                curaga_most_missing_hp = best_aoe_info.curaga_most_missing_hp
            elseif can_curaga and curaga_priority then
                local mp_restored = best_aoe_info.curaga_potential_hp * 0.08
            else
                best_target = best_single.name
            end

            if can_curaga and should_aoe then
                local name, spell = l_funcs.get_highest_tier_cure(player, gd.cures["curaga"], curaga_most_missing_hp)
                best_spell = name
            end

            -- no valid aoe so do single target
            if best_spell == nil then
                local name, spell = l_funcs.get_highest_tier_cure(player, gd.cures["cure"], best_single.cure_potential_hp)
                local fc_name, fc_spell = l_funcs.get_highest_tier_cure(player, gd.cures["fullcure"], best_single.cure_potential_hp)
                if name ~= nil then
                    if player_mp < 80 and (name == "Cure" or name == "Cure II" or name == "Cure III") and fc_name ~= nil then
                        best_spell = fc_name
                    else
                        best_spell = name
                    end
                end
            end
            
            if best_target ~= nil and best_spell ~= nil then
                return use_command(best_spell, best_target)(player, params)
            end
            return false
        end),
        initalize_gambit = (function()
        end),
        should_proc = (function(player, params)
            -- index is the windower.ffxi.get_mob_by_index(index)
            --player.party_buffs[index]

            --player.party is windower.ffxi.get_party()
            party_info = {}
            local is_anyone_under_cure_percent = false

            for k, v in pairs(player.party) do
                if type(v) == 'table' then
                    -- matches p0-p5 (party) and a1p0-a2p5 (alliance) - both are valid single target cure targets
                    if string.find(tostring(k), "p") then
                        -- If mob is nil then the player is not in the zone and we can't cure dead people or people out of range
                        if v.hp > 0 and v.mob ~= nil and (distance(v.mob.x, v.mob.y, player.self.x, player.self.y) < 21) then
                            if v.hpp <= 80 then
                                is_anyone_under_cure_percent = true
                            end
                            party_info[v.name] = {}
                            if string.find(tostring(k), "a") then
                                party_info[v.name].is_alliance_member = true
                            else
                                party_info[v.name].is_alliance_member = false
                            end
                            party_info[v.name].curaga_num_in_range = 0
                            party_info[v.name].curaga_num_in_range_under_cure_percent = 0
                            party_info[v.name].curaga_potential_percent = 0
                            party_info[v.name].curaga_potential_hp = 0
                            party_info[v.name].curaga_potential_avg_hp = 0
                            party_info[v.name].curaga_critical_potential = 0
                            party_info[v.name].curaga_num_in_range_critical_percent = 0
                            party_info[v.name].curaga_most_missing_hp = 0
                            
                            local max = v.hp/(v.hpp/100)
                            local missing = max - v.hp
                            party_info[v.name].is_critical = v.hpp <= 55
                            party_info[v.name].is_under_cure_precent = v.hpp <= 80
                            party_info[v.name].cure_potential_hp = missing
                            party_info[v.name].hp = v.hp

                            for kt, vt in pairs(player.party) do
                                if type(vt) == 'table' and not string.find(tostring(kt), "a") then
                                    if vt.hp > 0 and vt.mob ~= nil then
                                        -- If the party member (vt) is within curaga range of the cast target (v)
                                        if distance(v.mob.x, v.mob.y, vt.mob.x, vt.mob.y) < 10 then
                                            party_info[v.name].curaga_num_in_range = party_info[v.name].curaga_num_in_range + 1
                                            if vt.hpp <= 80 then
                                                party_info[v.name].curaga_num_in_range_under_cure_percent = party_info[v.name].curaga_num_in_range_under_cure_percent + 1
                                            end
                                            party_info[v.name].curaga_potential_percent = party_info[v.name].curaga_potential_percent + (100 - vt.hpp)
                                            local max_hp = vt.hp/(vt.hpp/100)
                                            local missing_hp = max_hp - vt.hp
                                            party_info[v.name].curaga_potential_hp = party_info[v.name].curaga_potential_hp + missing_hp
                                            if missing_hp > party_info[v.name].curaga_most_missing_hp then
                                                party_info[v.name].curaga_most_missing_hp = missing_hp
                                            end
                                            if vt.hpp <= 55 then
                                                party_info[v.name].curaga_critical_potential =  party_info[v.name].curaga_critical_potential + (100 - vt.hpp)
                                                party_info[v.name].curaga_num_in_range_critical_percent = party_info[v.name].curaga_num_in_range_critical_percent + 1
                                            end
                                        end
                                    end
                                end
                            end

                            if party_info[v.name].curaga_num_in_range > 0 then
                                party_info[v.name].curaga_potential_avg_hp = party_info[v.name].curaga_potential_hp / party_info[v.name].curaga_num_in_range
                            end
                        end
                    end
                end
            end
            return is_anyone_under_cure_percent
        end)
    }
    return obj
end

M.cond = cond

return M