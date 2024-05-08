local M = {}

local gd = require('gambits/gambit_defines')

local l_funcs = {}
l_funcs.get_highest_tier_buff = function (player, buff, is_target_self, allow_self)
    local main_job_id = player.instance.main_job_id
    local main_job_level = player.instance.main_job_level
    local sub_job_id = player.instance.sub_job_id
    local sub_job_level = player.instance.sub_job_level
    local highest = nil
    local spell = nil

    for i, b in ipairs(buff) do
        spell = res.spells:with('name', b)
        if spell ~= nil and player.spells[spell.id] then
            if ((spell.levels[main_job_id] ~= nil and spell.levels[main_job_id] <= main_job_level) or (spell.levels[sub_job_id] ~= nil and spell.levels[sub_job_id] <= sub_job_level)) and (is_target_self or allow_self or (spell.targets['Party'] or spell.targets['Enemy'] or spell.targets['NPC'])) then
                highest = b
                break
            end
        end
    end

    return highest, spell
end

function titleCase(first, rest)
    return first:upper()..rest:lower()
end

function cond(bundle_key)
    local obj = {
        initalize_condition = (function()
        end),
        should_proc = (function(player, params)
            local buffname = params.bundle[bundle_key]
            buffname = buffname:gsub("-","")
            buffname = buffname:gsub(" ","")
            buffname = gd.buffs[buffname]
            if buffname == nil then
                return false, params
            end

            local buff, spell = l_funcs.get_highest_tier_buff(player, buffname, true, true)

            params.bundle[bundle_key] = buff

            return buff ~= nil, params
        end)
    }
    return obj
end

M.cond = cond

return M