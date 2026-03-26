Gambits = include('gambit_requires')

set_global_condition("useEntrust", false)()
set_global_condition("useBog", false)()
set_global_condition("useDematerialize", false)()
set_global_condition("useEcliptic", false)()
set_global_condition("useLasting", false)()

set_global_condition("leader", "Genoxd")()

set_global_condition("spam_poisona", false)()

set_global_condition("entrust_spell", "Indi-STR")()
set_global_condition("self_indi", "Indi-Fury")()
set_global_condition("geo_spell", "Geo-Frailty")()

--tag_spell = "Absorb-TP"
tag_spell = "Dia II"

registered_gambits = {

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_in_range.cond("Dagda"),
    --         Gambits.tp_above_cond.cond(3000)
    --     },
    --     use_command("Dagda", "t")
    -- ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.debuff_active_on_player_cond.cond(S{"Petrification", "Sleep"}, "Soade"),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),

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
            Gambits.chat_match_part.cond("set", 0, nil),
            Gambits.chat_match_part.cond("entrust", 1, nil),
            Gambits.chat_extract_part.cond(2, "g_cond_value", nil),
            Gambits.chat_translate_buff.cond("g_cond_value")
        },
        queue_use_commands(
            set_global_condition("entrust_spell", "--bundle"), 
            (function() windower.send_command('input /p Set Entrust to '..tostring(get_global_condition("entrust_spell")())) return 0.1 end)
        )
    ),
	
	Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_part.cond("set", 0, nil),
            Gambits.chat_match_part.cond("geo", 1, nil),
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
            Gambits.chat_match_part.cond("set", 0, nil),
            Gambits.chat_match_part.cond("indi", 1, nil),
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
            Gambits.chat_match_part.cond("set", 0, nil),
            Gambits.chat_match_part.cond("leader", 1, nil),
            Gambits.chat_extract_part.cond(2, "g_cond_value", nil),
        },
        queue_use_commands(
            set_global_condition("leader", "--bundle"),
            (function() windower.send_command('input /p Set leader to '..tostring(get_global_condition("leader")())) return 0.1 end)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Reraise", 1),
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
            Gambits.buff_not_active_cond.cond("Colure Active", 1),
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
            Gambits.leader_target_is.cond(get_global_condition("leader"), S{
                "Abject Acuex", 
                "Biune Elemental",
                "Esurient Botulus"
            }),
            Gambits.leader_target_name_changed_cond.cond(get_global_condition("leader"), "14dcce0b-2028-4872-9f27-e9e9b21c64b2"),
        },
        queue_use_commands(
            (function()
                set_global_condition("entrust_spell", "Indi-INT")()
                set_global_condition("self_indi", "Indi-Acumen")()
                set_global_condition("geo_spell", "Geo-Malaise")()
                set_global_condition("useEntrust", false)()
                set_global_condition("useBog", false)()
                set_global_condition("useDematerialize", false)()
                set_global_condition("useEcliptic", false)()
                set_global_condition("useLasting", false)()
                windower.send_command('input /p Abject Acuex - Geo-Malaise and Indi-Acumen')
                return 0.1
            end),
            use_command("Indi-Acumen", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.leader_target_is.cond(get_global_condition("leader"), S{
                "Abject Leech", 
                "Abject Hecteyes", 
                "Abject Obdella", 
                "Biune Umbril", 
                "Biune Porxie",
                "Cachaemic Corse",
                "Cachaemic Ghost",
                "Cachaemic Ghost",
                "Cachaemic Skeleton",
                "Cachaemic Bhoot",
                "Demisang Fomor",
                "Demisang Deleterious",
                "Esurient Slime",
                "Esurient Slug",
                "Esurient Flan",
                "Fetid Veela",
                "Gyvewrapped Hound",
                "Gyvewrapped Dullahan",
                "Gyvewrapped Vampyr",
                "Gyvewrapped Naraka"
            }),
            Gambits.leader_target_name_changed_cond.cond(get_global_condition("leader"), "14dcce0b-2028-4872-9f27-e9e9b21c64b2"),
        },
        queue_use_commands(
            (function()
                set_global_condition("entrust_spell", "Indi-STR")()
                set_global_condition("self_indi", "Indi-Fury")()
                set_global_condition("geo_spell", "Geo-Frailty")()
                set_global_condition("useEntrust", false)()
                set_global_condition("useBog", false)()
                set_global_condition("useDematerialize", false)()
                set_global_condition("useEcliptic", false)()
                set_global_condition("useLasting", false)()
                windower.send_command('input /p Using Geo-Frailty and Indi-Fury')
                return 0.1
            end),
            use_command("Indi-Fury", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.leader_target_is.cond(get_global_condition("leader"), S{
                "Ghatjot",
                "Leshonn",
                "Skomora",
                "Degei",
                "Dhartok",
                "Gartell",
                "Aita"
            }),
            Gambits.leader_target_name_changed_cond.cond(get_global_condition("leader"), "14dcce0b-2028-4872-9f27-e9e9b21c64b2"),
        },
        queue_use_commands(
            (function()
                set_global_condition("entrust_spell", "Indi-STR")()
                set_global_condition("self_indi", "Indi-Fury")()
                set_global_condition("geo_spell", "Geo-Frailty")()
                set_global_condition("useEntrust", true)()
                set_global_condition("useBog", true)()
                set_global_condition("useDematerialize", true)()
                set_global_condition("useEcliptic", true)()
                set_global_condition("useLasting", true)()
                windower.send_command('input /p Boss Target - Using JAs, Geo-Frailty, Indi-Fury, and entrust Indi-STR')
                return 0.1
            end),
            use_command("Indi-Fury", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.leader_target_is.cond(get_global_condition("leader"), S{
                "Aminon"
            }),
            Gambits.leader_target_name_changed_cond.cond(get_global_condition("leader"), "14dcce0b-2028-4872-9f27-e9e9b21c64b2"),
        },
        queue_use_commands(
            (function()
                set_global_condition("entrust_spell", "Indi-Precision")()
                set_global_condition("self_indi", "Indi-Fury")()
                set_global_condition("geo_spell", "Geo-Frailty")()
                set_global_condition("useEntrust", false)()
                set_global_condition("useBog", true)()
                set_global_condition("useDematerialize", true)()
                set_global_condition("useEcliptic", true)()
                set_global_condition("useLasting", true)()
                windower.send_command('input /p Aminon - Using JAs, Geo-Frailty, Indi-Fury, and entrust Indi-Precision')
                return 0.1
            end),
            use_command("Indi-Fury", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.leader_target_is.cond(get_global_condition("leader"), S{"Triboulex"}),
            Gambits.leader_target_name_changed_cond.cond(get_global_condition("leader"), "14dcce0b-2028-4872-9f27-e9e9b21c64b2"),
        },
        queue_use_commands(
            (function()
                set_global_condition("entrust_spell", "Indi-Attunement")()
                set_global_condition("self_indi", "Indi-Fury")()
                set_global_condition("geo_spell", "Geo-Frailty")()
                set_global_condition("useEntrust", true)()
                set_global_condition("useBog", true)()
                set_global_condition("useDematerialize", true)()
                set_global_condition("useEcliptic", true)()
                set_global_condition("useLasting", true)()
                windower.send_command('input /p Triboulex - Using JAs, Geo-Frailty, Indi-Fury, and entrust Indi-Attunement')
                return 0.1
            end),
            use_command("Indi-Fury", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.leader_target_is.cond(get_global_condition("leader"), S{"Gartell", "Aita"}),
        },
        use_command("Bolster", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useBog", true, false),
            Gambits.does_not_have_pet.cond(),
            Gambits.buff_not_active_cond.cond("Bolster", 1),
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
            Gambits.does_not_have_pet.cond(),
            Gambits.bundle_set_spell.cond("--global", "geo_spell"),
            Gambits.leader_target_is.cond(get_global_condition("leader"), S{
                "Aminon"
            }),
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
            Gambits.check_global_equals.cond("useDematerialize", true, false),
            Gambits.has_pet.cond(),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.ja_recast_ready_cond.cond("Dematerialize"),
        },
        use_command("Dematerialize", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useEcliptic", true, false),
            Gambits.has_pet.cond(),
            Gambits.buff_not_active_cond.cond("Bolster", 1),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.ja_recast_ready_cond.cond("Ecliptic Attrition"),
        },
        use_command("Ecliptic Attrition", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useLasting", true, false),
            Gambits.has_pet.cond(),
            Gambits.buff_active_cond.cond("Bolster", 1),
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
            Gambits.leader_target_changed_cond.cond(get_global_condition("leader"), "b0a06a35-6a3a-4d54-8bea-45af78ddfbdd"), 
            Gambits.has_pet.cond(),
            Gambits.pet_in_range_to_target.cond(get_global_condition("leader"), 6, true),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.bundle_set_spell.cond(tag_spell),
            Gambits.bundle_set_geo_spell_target.cond(get_global_condition("leader")),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useEntrust", true, false),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")),
            Gambits.ja_recast_ready_cond.cond("Entrust"),
        },
        use_command("Entrust", "me")
    ),

	Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_active_cond.cond("Entrust", 1),
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
            Gambits.chat_match_cond.cond("set acc", nil),
        },
        queue_use_commands(
            (function()
                set_global_condition("entrust_spell", "Indi-STR")()
                set_global_condition("self_indi", "Indi-Fury")()
                set_global_condition("geo_spell", "Geo-Precision")()
                windower.send_command('input /p Set: Geo-Precision, Indi-Fury, and entrust Indi-STR')
                return 0.1
            end),
            use_command("Indi-Fury", "me"),
            use_command("Full Circle", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("set mevd", nil),
        },
        queue_use_commands(
            (function()
                set_global_condition("entrust_spell", "Indi-STR")()
                set_global_condition("self_indi", "Indi-Fury")()
                set_global_condition("geo_spell", "Geo-Attunement")()
                windower.send_command('input /p Set: Geo-Attunement, Indi-Fury, and entrust Indi-STR')
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
            Gambits.chat_match_cond.cond("set macc", nil),
        },
        queue_use_commands(
            (function()
                set_global_condition("entrust_spell", "Indi-INT")()
                set_global_condition("self_indi", "Indi-Focus")()
                set_global_condition("geo_spell", "Geo-Languor")()
                windower.send_command('input /p Set: Geo-Languor, Indi-Focus, and entrust Indi-INT')
                return 0.1
            end),
            use_command("Indi-Focus", "me"),
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

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("spam poisona", nil),
        },
        queue_use_commands(
            set_global_condition("spam_poisona", true)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("stop poisona", nil),
        },
        queue_use_commands(
            set_global_condition("spam_poisona", false)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("spam_poisona", true, false),
            Gambits.ma_recast_ready_cond.cond("Poisona")
        },
        queue_use_commands(
            (function()
                windower.send_command('input //poisona Genoxd')
                return 0.1
            end)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Dagda", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.leader_target_is.cond(get_global_condition("leader"), S{
                "Aminon"
            }),
            Gambits.ma_recast_ready_cond.cond("Absorb-TP"),
            Gambits.bundle_set_spell.cond("Absorb-TP"),
            Gambits.bundle_set_geo_spell_target.cond(get_global_condition("leader")),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),
}