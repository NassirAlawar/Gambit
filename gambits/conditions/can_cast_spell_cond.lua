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

-- cities used to determine if we can cast geomancy or summoning magic
restricted_cities = {
	[1] = "Heavens Tower",
	[2] = "Port Windurst",
	[3] = "Windurst Walls",
	[4] = "Windurst Waters",
	[5] = "Windurst Woods",
	[6] = "Mhaura",
	[7] = "Selbina",
	[8] = "Port Jeuno",
	[9] = "Lower Jeuno",
	[10] = "Upper Jeuno",
	[11] = "Ru'Lude Gardens",
	[12] = "Tavnazian Safehold",
	[13] = "Chateau d'Oraguille",
	[14] = "Northern San d'Oria",
	[15] = "Port San d'Oria",
	[16] = "Southern San d'Oria",
	[17] = "Bastok Markets",
	[18] = "Bastok Mines",
	[19] = "Metalworks",
	[20] = "Port Bastok",
	[21] = "Rabao",
	[22] = "Kazham",
	[23] = "Norg",
	[24] = "Aht Urhgan Whitegate",
	[25] = "Nashmau",
	[26] = "Western Adoulin",
	[27] = "Eastern Adoulin",
	[28] = "Mog Garden",
	[29] = "Silver Knife",
	[30] = "Celennia Memorial Library",
	[31] = "San d'Oria-Jeuno Airship",
	[32] = "Bastok-Jeuno Airship",
	[33] = "Windurst-Jeuno Airship",
	[34] = "Kazham-Jeuno Airship",
	[35] = "Feretory",
	[36] = "Chocobo Circuit",
	[37] = "The Colosseum",
	[38] = "unknown",
	[39] = "Mordion Gaol",
}

-- Places nothing is allowed to be cast
blocked_cities =
{
	[1] = {name='unknown'},
	[2] = {name='Mordion Gaol'}
}

function cond(spell_name, cast_while_moving)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local name = spell_name
            if name == "--bundle" then
                name = params.bundle.spell.name:gsub("^%l", string.upper)
            end
            
            local spell = res.spells:with('name', name)
            local main_job_id = player.instance.main_job_id
            local main_job_level = player.instance.main_job_level
            local sub_job_id = player.instance.sub_job_id
            local sub_job_level = player.instance.sub_job_level
            local status = statuses[player.instance.status]
			local zone = res.zones[player.info.zone]
            
            local good_to_go = true
            good_to_go = good_to_go and (player.instance.vitals.hp > 0)
            good_to_go = good_to_go and (player.ma_recasts[spell.id] == 0)
            good_to_go = good_to_go and ((spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= main_job_level) or (spell.levels[sub_job_id] ~= nil and spell.levels[sub_job_id] <= sub_job_level))
            good_to_go = good_to_go and (player.instance.vitals.mp >= spell.mp_cost)
            
            good_to_go = good_to_go and player.buffs["silence"] == nil
            good_to_go = good_to_go and player.buffs["petrification"] == nil
            good_to_go = good_to_go and player.buffs["stun"] == nil
            good_to_go = good_to_go and player.buffs["charm"] == nil
            good_to_go = good_to_go and player.buffs["sleep"] == nil
            good_to_go = good_to_go and player.buffs["terror"] == nil
            good_to_go = good_to_go and player.buffs["mute"] == nil
            good_to_go = good_to_go and player.buffs["Omerta"] == nil
			good_to_go = good_to_go and player.buffs["Chocobo"] == nil
			
			good_to_go = good_to_go and not table.contains(blocked_cities, zone.en)
			good_to_go = good_to_go and not (spell.type == 'Geomancy' and table.contains(restricted_cities, zone.en))
			good_to_go = good_to_go and not (spell.type == 'SummonerPact' and table.contains(restricted_cities, zone.en))
            
            good_to_go = good_to_go and status['en'] == "Idle" or status['en'] == "Engaged"
            good_to_go = good_to_go and (not player.is_moving) or (cast_while_moving ~= nil and cast_while_moving)
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