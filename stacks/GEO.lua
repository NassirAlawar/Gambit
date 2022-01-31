Gambits = include('gambit_requires')

set_global_condition("useEntrust", false)()
set_global_condition("useBog", false)()
set_global_condition("useDematerialize", false)()
set_global_condition("useEcliptic", false)()
set_global_condition("entrust_spell", "Indi-Frailty")()
set_global_condition("self_indi", "Indi-Refresh")()

registered_gambits = {

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Reraise"),
			Gambits.can_cast_spell_cond.cond("Reraise"),
        },
        use_command("Reraise", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_part.cond("set", 0, "Genoxd"),
            Gambits.chat_match_part.cond("entrust", 1, "Genoxd"),
            Gambits.chat_extract_part.cond(2, "g_cond_value", "Genoxd"),
        },
        set_global_condition("self_indi", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_part.cond("test", 0, nil),
            Gambits.chat_match_part.cond("c", 1, nil),
            Gambits.bundle_set_spell.cond("--global", "self_indi"),
            Gambits.bundle_set_spell_target.cond("me"),
            Gambits.can_cast_spell_cond.cond("--bundle"),
        },
        --queue_use_commands(use_command("Cure", "me"), use_command("Cure II", "me"), use_command("--bundle", "--bundle"))
        --queue_use_commands(use_command("Cure", "me"), use_command("Cure", "me"))
        (function() windower.add_to_chat(128, "bob") end)
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
            Gambits.chat_match_cond.cond("use entrust", nil),
        },
        set_global_condition("useEntrust", true)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("stop entrust", nil),
        },
        set_global_condition("useEntrust", false)
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
            Gambits.leader_is_engaged.cond("Genoxd"),
            Gambits.pet_not_in_range_to_target.cond("Genoxd", 6, true),
            Gambits.ja_recast_ready_cond.cond("Full Circle"),
        },
        use_command("Full Circle", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useBog", true),
            Gambits.does_not_have_pet.cond(),
            Gambits.leader_is_engaged.cond("Genoxd"),
            Gambits.ja_recast_ready_cond.cond("Blaze of Glory"),
        },
        use_command("Blaze of Glory", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.does_not_have_pet.cond(),
            Gambits.bundle_set_spell.cond("Geo-Torpor"),
            Gambits.leader_is_engaged.cond("Genoxd"),
            Gambits.bundle_set_geo_spell_target.cond("Genoxd"),
            Gambits.can_cast_spell_cond.cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useDematerialize", true),
            Gambits.has_pet.cond(),
            Gambits.ja_recast_ready_cond.cond("Dematerialize"),
        },
        use_command("Dematerialize", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useEcliptic", true),
            Gambits.has_pet.cond(),
            Gambits.ja_recast_ready_cond.cond("Ecliptic Attrition"),
        },
        use_command("Ecliptic Attrition", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.has_pet.cond(),
            Gambits.pet_hpp_below.cond(50),
            Gambits.ja_recast_ready_cond.cond("Life Cycle"),
        },
        use_command("Life Cycle", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.has_pet.cond(),
            Gambits.bundle_set_spell.cond("Stone"),
            Gambits.bundle_set_geo_spell_target.cond("Genoxd"),
            Gambits.leader_is_engaged.cond("Genoxd"),
            Gambits.leader_target_changed_cond.cond("Genoxd", "abc"),
            Gambits.can_cast_spell_cond.cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("useEntrust", true),
            Gambits.ja_recast_ready_cond.cond("Entrust"),
        },
        use_command("Entrust", "me")
    ),

	Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_active_cond.cond("Entrust"),
            Gambits.bundle_set_spell.cond("--global", "entrust_spell"),
            Gambits.bundle_set_spell_target.cond("Genoxd"),
			Gambits.can_cast_spell_cond.cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
    ),
}