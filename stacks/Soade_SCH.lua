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
            Gambits.buff_not_active_cond.cond("Light Arts", 1),
            Gambits.buff_not_active_cond.cond("Addendum: White", 1),
            Gambits.ja_recast_ready_cond.cond("Light Arts")
        },
        use_command("Light Arts", "me")
    ),

    Gambits.handle_cures.cond(),
}