Gambits = include('gambit_requires')

set_global_condition("dia", false)()
set_global_condition("hastes", false)()

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
            Gambits.buff_not_active_cond.cond("Composure", 1),
            Gambits.ja_recast_ready_cond.cond("Composure")
        },
        use_command("Composure", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.can_cast_spell_cond.cond("Refresh III"),
            Gambits.buff_not_active_cond.cond("Refresh", 1)
        },
        use_command("Refresh III", "me")
    ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.can_cast_spell_cond.cond("Haste II"),
    --         Gambits.buff_not_active_cond.cond("Haste", 1)
    --     },
    --     use_command("Haste II", "me")
    -- ),

    Gambits.handle_cures.cond(),
}