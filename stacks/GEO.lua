Gambits = include('gambit_requires')

set_global_condition("useEntrust", false)()
set_global_condition("useBog", false)()
set_global_condition("useDematerialize", false)()
set_global_condition("useEcliptic", false)()
set_global_condition("useLasting", false)()

set_global_condition("leader", "Genoxd")()
--set_global_condition("leader", "Benjamus")()

--SMN
--set_global_condition("entrust_spell", "Indi-Refresh")()
--set_global_condition("self_indi", "Indi-Malaise")()
--set_global_condition("geo_spell", "Geo-Frailty")()

--SAM
--set_global_condition("self_indi", "Indi-Precision")()
--set_global_condition("self_indi", "Indi-Frailty")()
set_global_condition("entrust_spell", "Indi-STR")()
set_global_condition("self_indi", "Indi-Fury")()
set_global_condition("geo_spell", "Geo-Frailty")()

--MAB
--set_global_condition("entrust_spell", "Indi-INT")()
--set_global_condition("self_indi", "Indi-Malaise")()
--set_global_condition("self_indi", "Indi-Acumen")()
--set_global_condition("geo_spell", "Geo-Malaise")()

--BLU DOOM
--set_global_condition("entrust_spell", "Indi-INT")()
--set_global_condition("self_indi", "Indi-Acumen")()
--set_global_condition("self_indi", "Indi-Focus")()
--set_global_condition("geo_spell", "Geo-Focus")()
--set_global_condition("geo_spell", "Geo-Languor")()

registered_gambits = {
    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("use entrust", nil),
        },
        queue_use_commands(
            set_global_condition("useEntrust", true), 
            (function() windower.send_command('input /p Use Entrust: true') return 0.1 end)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("stop entrust", nil),
        },
        queue_use_commands(
            set_global_condition("useEntrust", false), 
            (function() windower.send_command('input /p Use Entrust: false') return 0.1 end)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_part.cond("set", 0, get_global_condition("leader")),
            Gambits.chat_match_part.cond("entrust", 1, get_global_condition("leader")),
            Gambits.chat_extract_part.cond(2, "g_cond_value", get_global_condition("leader")),
            Gambits.chat_translate_buff.cond("g_cond_value")
        },
        queue_use_commands(
            set_global_condition("entrust_spell", "--bundle"), 
            (function() windower.send_command('input /p Set Entrust to '..tostring(get_global_condition("entrust_spell")())) return 0.1 end)
        )
    ),
	
	Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_part.cond("set", 0, get_global_condition("leader")),
            Gambits.chat_match_part.cond("geo", 1, get_global_condition("leader")),
            Gambits.chat_extract_part.cond(2, "g_cond_value", nil),
            Gambits.chat_translate_buff.cond("g_cond_value")
        },
        queue_use_commands(
            set_global_condition("geo_spell", "--bundle"), 
            (function() windower.send_command('input /p Set Geo to '..tostring(get_global_condition("geo_spell")())) return 0.1 end),
            use_command("Full Circle", "me")
        )
    ),
	
	Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_part.cond("set", 0, get_global_condition("leader")),
            Gambits.chat_match_part.cond("indi", 1, get_global_condition("leader")),
            Gambits.chat_extract_part.cond(2, "g_cond_value", nil),
            Gambits.chat_translate_buff.cond("g_cond_value")
        },
        queue_use_commands(
            set_global_condition("self_indi", "--bundle"),
            (function() windower.send_command('input /p Set Indi to '..tostring(get_global_condition("self_indi")())) return 0.1 end),
            (function() use_command(get_global_condition("self_indi")(), "me")() end)
        )
    ),
	
	Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_part.cond("set", 0, get_global_condition("leader")),
            Gambits.chat_match_part.cond("leader", 1, get_global_condition("leader")),
            Gambits.chat_extract_part.cond(2, "g_cond_value", nil),
        },
        queue_use_commands(
            set_global_condition("leader", "--bundle"),
            (function() windower.send_command('input /p Set leader to '..tostring(get_global_condition("leader")())) return 0.1 end)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Reraise"),
			Gambits.can_cast_spell_cond.cond("Reraise"),
        },
        use_command("Reraise", "me")
    ),

    -- Cast buffing spells on request
    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_buff.cond(nil),
            Gambits.can_cast_spell_cond.cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
    ),
	
	Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Colure Active"),
            Gambits.bundle_set_spell.cond("--global", "self_indi"),
            Gambits.bundle_set_spell_target.cond("me"),
			Gambits.can_cast_spell_cond.cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.pet_not_in_range_to_target.cond(get_global_condition("leader"), 6, true),
            Gambits.ja_recast_ready_cond.cond("Full Circle"),
        },
        use_command("Full Circle", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useBog", true),
            Gambits.does_not_have_pet.cond(),
            Gambits.buff_not_active_cond.cond("Bolster"),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.ja_recast_ready_cond.cond("Blaze of Glory"),
        },
        use_command("Blaze of Glory", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.does_not_have_pet.cond(),
            Gambits.bundle_set_spell.cond("--global", "geo_spell"),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.bundle_set_geo_spell_target.cond(get_global_condition("leader")),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        queue_use_commands(
            use_command("--bundle", "--bundle"),
            (function()
                if g_bundle["b0a06a35-6a3a-4d54-8bea-45af78ddfbdd"] == nil then
                    g_bundle["b0a06a35-6a3a-4d54-8bea-45af78ddfbdd"] = {}
                end
                local mob = windower.ffxi.get_mob_by_name(get_global_condition("leader")())
                local current_target_index = mob.target_index
                g_bundle["b0a06a35-6a3a-4d54-8bea-45af78ddfbdd"].last_target_index = current_target_index
            end)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useDematerialize", true),
            Gambits.has_pet.cond(),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.ja_recast_ready_cond.cond("Dematerialize"),
        },
        use_command("Dematerialize", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useEcliptic", true),
            Gambits.has_pet.cond(),
            Gambits.buff_not_active_cond.cond("Bolster"),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.ja_recast_ready_cond.cond("Ecliptic Attrition"),
        },
        use_command("Ecliptic Attrition", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useLasting", true),
            Gambits.has_pet.cond(),
            Gambits.buff_active_cond.cond("Bolster"),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.ja_recast_ready_cond.cond("Lasting Emanation"),
        },
        use_command("Lasting Emanation", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.has_pet.cond(),
            Gambits.pet_hpp_below.cond(50),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.ja_recast_ready_cond.cond("Life Cycle"),
        },
        use_command("Life Cycle", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.has_pet.cond(),
            Gambits.pet_in_range_to_target.cond(get_global_condition("leader"), 6, true),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.leader_target_changed_cond.cond(get_global_condition("leader"), "b0a06a35-6a3a-4d54-8bea-45af78ddfbdd"), 
            Gambits.bundle_set_spell.cond("Stone"),
            Gambits.bundle_set_geo_spell_target.cond(get_global_condition("leader")),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useEntrust", true),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.ja_recast_ready_cond.cond("Entrust"),
        },
        use_command("Entrust", "me")
    ),

	Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_active_cond.cond("Entrust"),
            Gambits.bundle_set_spell.cond("--global", "entrust_spell"), 
            Gambits.bundle_set_spell_target.cond("--global", "leader"),
			Gambits.can_cast_spell_cond.cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("set attack", nil),
        },
        queue_use_commands(
            (function()
                set_global_condition("entrust_spell", "Indi-STR")()
                set_global_condition("self_indi", "Indi-Fury")()
                set_global_condition("geo_spell", "Geo-Frailty")()
                windower.send_command('input /p Set: Geo-Frailty, Indi-Fury, and entrust Indi-STR')
                return 0.1
            end),
            use_command("Indi-Fury", "me"),
            use_command("Full Circle", "me")
        )
    ),
    
    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("set hybrid", nil),
        },
        queue_use_commands(
            (function()
                set_global_condition("entrust_spell", "Indi-STR")()
                set_global_condition("self_indi", "Indi-Malaise")()
                set_global_condition("geo_spell", "Geo-Frailty")()
                windower.send_command('input /p Set: Geo-Frailty, Indi-Malaise, and entrust Indi-STR')
                return 0.1
            end),
            use_command("Indi-Malaise", "me"),
            use_command("Full Circle", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("set blu", nil),
        },
        queue_use_commands(
            (function()
                set_global_condition("entrust_spell", "Indi-Refresh")()
                set_global_condition("self_indi", "Indi-Focus")()
                set_global_condition("geo_spell", "Geo-Languor")()
                windower.send_command('input /p Set: Geo-Languor, Indi-Focus, and entrust Indi-Refresh')
                return 0.1
            end),
            use_command("Indi-Focus", "me"),
            use_command("Full Circle", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("set mab", nil),
        },
        queue_use_commands(
            (function()
                set_global_condition("entrust_spell", "Indi-INT")()
                set_global_condition("self_indi", "Indi-Acumen")()
                set_global_condition("geo_spell", "Geo-Malaise")()
                windower.send_command('input /p Set: Geo-Malaise, Indi-Acumen, and entrust Indi-INT')
                return 0.1
            end),
            use_command("Indi-Acumen", "me"),
            use_command("Full Circle", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("set trash jas", nil),
        },
        queue_use_commands(
            (function()
                set_global_condition("useEntrust", false)()
                set_global_condition("useBog", false)()
                set_global_condition("useDematerialize", false)()
                set_global_condition("useEcliptic", false)()
                windower.send_command('input /p Stopping JA usage')
                return 0.1
            end)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("set boss jas", nil),
        },
        queue_use_commands(
            (function()
                set_global_condition("useEntrust", true)()
                set_global_condition("useBog", true)()
                set_global_condition("useDematerialize", true)()
                set_global_condition("useEcliptic", true)()
                set_global_condition("useLasting", true)()
                windower.send_command('input /p Using Entrust, Dematerialize, Lasting (w/Bolster), and BoG+Ecliptic (w/o Bolster)')
                return 0.1
            end)
        )
    ),
}