Gambits = include('gambit_requires')

set_global_condition("leader", "Genoxd")()

registered_gambits = {
    Gambits.multi_condition_trigger.cond(
        {
            Gambits.ma_recast_ready_cond.cond("Absorb-TP"),
            Gambits.bundle_set_spell.cond("Absorb-TP"),
            Gambits.bundle_set_geo_spell_target.cond(get_global_condition("leader")),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),
}