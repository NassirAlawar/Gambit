Gambits = include('gambit_requires')

registered_gambits = {

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.buff_not_active_cond.cond("Enmity Boost", 1),
    --         Gambits.ma_recast_ready_cond.cond("Crusade"),
    --     },
    --     use_command("Crusade", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.ja_recast_ready_cond.cond("Sentinel"),
    --     },
    --     use_command("Sentinel", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.ja_recast_ready_cond.cond("Divine Emblem"),
    --     },
    --     use_command("Divine Emblem", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.ma_recast_ready_cond.cond("Flash")
    --     },
    --     use_command("Flash", "t")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.ja_recast_ready_cond.cond("Holy Circle"),
    --     },
    --     use_command("Holy Circle", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.ja_recast_ready_cond.cond("Rampart"),
    --     },
    --     use_command("Rampart", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.ja_recast_ready_cond.cond("Shield Bash"),
    --     },
    --     use_command("Shield Bash", "t")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.buff_not_active_cond.cond("Reprisal", 1),
    --         Gambits.buff_not_active_cond.cond("Palisade", 1),
    --         Gambits.ma_recast_ready_cond.cond("Reprisal"),
    --     },
    --     use_command("Reprisal", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.buff_not_active_cond.cond("Reprisal", 1),
    --         Gambits.buff_not_active_cond.cond("Palisade", 1),
    --         Gambits.ja_recast_ready_cond.cond("Palisade"),
    --     },
    --     use_command("Palisade", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.buff_not_active_cond.cond("Majesty", 1),
    --         Gambits.ja_recast_ready_cond.cond("Majesty"),
    --     },
    --     use_command("Majesty", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.hpp_below_cond.cond(60),
    --         Gambits.ma_recast_ready_cond.cond("Cure IV"),
    --     },
    --     use_command("Cure IV", "me")
    -- ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Savage Blade", "t")
    ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.buff_not_active_cond.cond("Enlight", 1),
    --         Gambits.ma_recast_ready_cond.cond("Enlight II"),
    --     },
    --     use_command("Enlight II", "me")
    -- ),
}