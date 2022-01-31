Gambits = include('gambit_requires')

set_global_condition("useJA", false)()
set_global_condition("use1Hr", false)()
set_global_condition("hasHonorMarch", false)()
set_global_condition("leader", "Akila")()

registered_gambits = {

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Reraise"),
			Gambits.can_cast_spell_cond.cond("Reraise"),
        },
        use_command("Reraise", "me")
    ),
    Gambits.handle_bard_songs.cond("leader")
}