Gambits = include('gambit_requires')

registered_gambits = {
    -- Echo Drops
    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_not_moving.cond(),
            Gambits.buff_active_cond.cond("Silenced"),
            Gambits.can_use_item.cond("Echo Drops"),
        },
        (function() windower.send_command('input /item "Echo Drops" <me>') end)
    ),

    -- Reraise
    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Reraise"),
            Gambits.bundle_pick_highest_tier_buff.cond("Reraise"),
            Gambits.bundle_set_spell_target.cond("me"),
			Gambits.can_cast_spell_cond.cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
    ),

    -- Curaga V
    -- Curaga IV
    -- Cure VI
    -- Cure V
    -- Cursna
    -- Stona
    -- Cure IV
    -- Paralyna
    -- Slow
    -- Cure III

    -- General Status Cure

    -- Buff on Request
    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_buff.chat_match_buff(nil),
            Gambits.can_cast_spell_cond.can_cast_spell_cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
    ),
}