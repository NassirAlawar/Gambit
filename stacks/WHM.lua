Gambits = include('gambit_requires')

set_global_condition("dia", false)()
set_global_condition("hastes", false)()

set_global_condition("leader", "Genoxd")()

set_global_condition("pull_mode", false)()

registered_gambits = {
    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_active_cond.cond("Silence", 1),
            --Gambits.can_use_item.cond("Echo Drops"),
        },
        (function() windower.send_command('input /item "Echo Drops" <me>') end)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_active_cond.cond("paralysis", 1),
            --Gambits.can_use_item.cond("Echo Drops"),
        },
        use_command("Paralyna", "me")
    ),
    
    Gambits.multi_condition_trigger.cond(
        {
            Gambits.can_cast_spell_cond.cond("Cure", true),
            Gambits.chat_match_cond.cond("soade buffs", nil),
        },
        queue_use_commands(
            use_command("Shellra V", "me"),
            use_command("Protectra V", "me"),
            use_command("Boost-STR", "me"),
            use_command("Barfira", "me"),
            use_command("Baramnesra", "me"),
            use_command("Auspice", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.can_cast_spell_cond.cond("Cure", true),
            Gambits.chat_match_cond.cond("soade waterbuffs", nil),
        },
        queue_use_commands(
            use_command("Shellra V", "me"),
            use_command("Protectra V", "me"),
            use_command("Boost-STR", "me"),
            use_command("Barwatera", "me"),
            use_command("Barpoisonra", "me"),
            use_command("Auspice", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Reraise", 1),
            Gambits.bundle_pick_highest_tier_buff.cond("Reraise"),
            Gambits.bundle_set_spell_target.cond("me"),
			Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.debuff_active_on_party_member_cond.cond(S{"Doom"}),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.leader_is_not_engaged.cond(get_global_condition("leader")),
            Gambits.chat_match_heal.cond(nil),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.handle_cures.cond(),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.leader_is_not_engaged.cond(get_global_condition("leader")),
            Gambits.debuff_active_on_party_member_cond.cond(S{
                "Bind", 
                "Weight"
            }),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("pull_mode", true, false),
            Gambits.bundle_set_spell.cond("Silence"),
            Gambits.bundle_find_unclaimed_target.cond(S{
                "Locus Colibri", 
                --"Apollyon Beetle", 
                "Apollyon Wasp",
                "Apollyon Antlion",
                "Apollyon Scorpion",
                "Temenos Orc"
            }, 
            20),
            Gambits.can_cast_spell_cond.cond("--bundle", true)
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_heal.cond(nil),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.debuff_active_on_party_member_cond.cond(S{"Petrification", "Sleep"}),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.debuff_active_on_party_member_cond.cond(S{"Defense Down", "Blind", "Slowed"}),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.debuff_active_on_party_member_cond.cond(S{"Gravity"}),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_buff.cond(nil),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Afflatus Solace", 1),
            Gambits.ja_recast_ready_cond.cond("Afflatus Solace")
        },
        use_command("Afflatus Solace", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Light Arts", 1),
            Gambits.ja_recast_ready_cond.cond("Light Arts")
        },
        use_command("Light Arts", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.can_cast_spell_cond.cond("Regen IV", true),
            Gambits.chat_match_cond.cond("regenga", nil),
        },
        queue_use_commands(
            use_command("Accession", "me"),
            use_command("Regen IV", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.can_cast_spell_cond.cond("Sneak", true),
            Gambits.chat_match_cond.cond("sneakga", nil),
        },
        queue_use_commands(
            use_command("Accession", "me"),
            use_command("sneak", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.can_cast_spell_cond.cond("Invisible", true),
            Gambits.chat_match_cond.cond("invisga", nil),
        },
        queue_use_commands(
            use_command("Accession", "me"),
            use_command("invisible", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("soade do hastes", nil),
        },
        set_global_condition("hastes", true)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("soade stop hastes", nil),
        },
        set_global_condition("hastes", true)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("soade pull", nil),
        },
        queue_use_commands(
            (function()
                windower.send_command('input /p Starting Pulls')
                return 0.01
            end),
            set_global_condition("pull_mode", true)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("soade stop pulling", nil),
        },
        queue_use_commands(
            (function()
                windower.send_command('input /p Stopping Pulls')
                return 0.01
            end),
            set_global_condition("pull_mode", false)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("soade use dia", nil),
        },
        set_global_condition("dia", true)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("soade stop dia", nil),
        },
        set_global_condition("dia", false)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("dia", true, false),
            Gambits.bundle_set_target_to_leaders_target.cond("Genoxd"),
            Gambits.bundle_set_spell.cond("Dia II"),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
            Gambits.once_per_fight.cond("7a34928c-cda5-45ec-8b78-9fa95a8f63ef")
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("hastes", true, false),
            Gambits.can_cast_spell_cond.cond("Haste"),
            Gambits.is_buff_missing_on_party_member.cond(S{"Genoxd", "Akila", "Tarurock", "Tankaru", "Benjamus", "Stepth", "Eviee", "Strange", "Xinef", "Byrth"}, "Haste"),
            Gambits.bundle_set_spell.cond("Haste"),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
            Gambits.is_target_valid.cond("--bundle", "--bundle")
        },
        use_command("--bundle", "--bundle")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Black Halo", "t")
    ),
}