Gambits = include('gambit_requires')

registered_gambits = {

	-- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.tp_above_cond.cond(350),
    --         Gambits.buff_not_active_cond.cond("Haste Samba", 1)
    --     },
    --     use_command("Haste Samba", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.tp_above_cond.cond(1000)
    --     },
    --     use_command("Black Halo", "t")
    -- ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.tp_above_cond.cond(500),
            Gambits.hpp_below_cond.cond(60)
        },
        use_command("Curing Waltz III", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.ma_recast_ready_cond.cond("Restoral"),
            Gambits.hpp_below_cond.cond(50)
        },
        use_command("Restoral", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.tp_above_cond.cond(1000),
            Gambits.target_is.cond(S{
                "Dendainsonne", 
                "Freke", 
                "Gorgimera",
                "Motsognir", 
                "Stoorworm",
                "Vampyr Jarl"
            }, false),
        },
        use_command("Savage Blade", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.tp_below_cond.cond(500),
            Gambits.target_is.cond(S{
                "Freke",
            }, false),
            Gambits.ma_recast_ready_cond.cond("Subduction")
        },
        use_command("Subduction", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.target_is.cond(S{
                "Dendainsonne", 
                "Freke", 
                "Gorgimera",
                "Motsognir", 
                "Stoorworm",
                "Vampyr Jarl"
            }, true),
            Gambits.ma_recast_ready_cond.cond("Subduction")
        },
        use_command("Subduction", "t")
    ),
}