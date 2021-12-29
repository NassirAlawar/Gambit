Gambits = require('gambit_requires')

set_global_condition("useEntrust", false)()

registered_gambits = {
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
            Gambits.check_global_equals.cond("useEntrust", true),
            Gambits.ja_recast_ready_cond.cond("Entrust"),
        },
        use_command("Entrust", "me")
    ),

	Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_active_cond.cond("Entrust"),
			Gambits.can_cast_spell_cond.cond("Indi-Frailty"),
        },
        use_command("Indi-Frailty", "Genoxd")
    ),
	
	Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Colure Active"),
			Gambits.can_cast_spell_cond.cond("Indi-Refresh"),
        },
        use_command("Indi-Refresh", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.does_not_have_pet.cond(),
            Gambits.bundle_set_spell.cond("Geo-Torpor"),
            Gambits.bundle_set_geo_spell_target.cond("Genoxd"),
            Gambits.can_cast_spell_cond.cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.has_pet.cond(),
            Gambits.bundle_set_spell.cond("Stone"),
            Gambits.bundle_set_geo_spell_target.cond("Genoxd"),
            Gambits.leader_target_changed_cond.cond("Genoxd", "abc"),
            Gambits.can_cast_spell_cond.cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
        --use_command("Geo-Precision", "Genoxd")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.pet_not_in_range_to_target.cond("Genoxd", 6),
            Gambits.ja_recast_ready_cond.cond("Full Circle"),
        },
        use_command("Full Circle", "me")
    ),
}