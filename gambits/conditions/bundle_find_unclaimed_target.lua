local M = {}

local gd = require('gambits/gambit_defines')

function get_party_ids()
	local party = windower.ffxi.get_party()
	local partyIds = S{}
	local index = 0
	while index < 6 do
		local indexstr = 'p'..tostring(index)
		if party[indexstr] ~= nil then
			if party[indexstr].mob ~= nil then
				partyIds:add(party[indexstr].mob.id)
			end
		end
		index = index + 1
	end

	if party.party2_leader ~= nil then
		index = 0
		while index < 6 do
			local indexstr = 'a'..tostring(10 + index)
			if party[indexstr] ~= nil then
				if party[indexstr].mob ~= nil then
					partyIds:add(party[indexstr].mob.id)
				end
			end
			index = index + 1
		end
	end

	if party.party3_leader ~= nil then
		index = 0
		while index < 6 do
			local indexstr = 'a'..tostring(20 + index)
			if party[indexstr] ~= nil then
				if party[indexstr].mob ~= nil then
					partyIds:add(party[indexstr].mob.id)
				end
			end
			index = index + 1
		end
	end

	return partyIds
end

function is_valid_engage_target(mob, max_distance)
	-- spawn_type 16 is 'Enemy'
	return mob.valid_target and mob.is_npc and mob.spawn_type == 16 and mob.hpp >= 1 and mob.xy_distance <= max_distance and mob.xy_distance >= 0 and ((mob.claim_id == 0) or mob.party_owned)
end

function find_nearest_target(player_mob, target_names, max_distance)
	local mobs = windower.ffxi.get_mob_array()
	local party_ids = get_party_ids()

	for k,mob in pairs(mobs) do
		mobs[k].party_owned = mob.claim_id ~= 0 and party_ids:contains(mob.claim_id)
		mobs[k].is_engaged = mob.status == 1
		mobs[k].xy_distance = distance(mob.x, mob.y, player_mob.x, player_mob.y)
		mobs[k].z_distance = math.abs(mob.z - player_mob.z)
	end
    
	local nearest_new_target = nil
	for mobid, mob in pairs(mobs) do
        if mob.xy_distance <= max_distance then
            if is_valid_engage_target(mob, max_distance) then
                if target_names:contains(mob.name) then
                    if nearest_new_target == nil or mob.xy_distance < nearest_new_target.xy_distance then
                        if not mob.party_owned then
                            nearest_new_target = mob
                        end
                    end
                end
            end
        end
	end

	return nearest_new_target
end

function cond(target_names, max_distance)
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

            if max_distance == nil then
                max_distance = 15
            end

            local target_mob = find_nearest_target(player.self, target_names, max_distance)

            if target_mob ~= nil then
                target_by_id = true
                target_id = target_mob.id
                target_index = target_mob.index
                target = target_mob.name
                success = true
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