Gambits = include('gambit_requires')

set_global_condition("useJA", false)()
set_global_condition("use1Hr", false)()
set_global_condition("hasHonorMarch", true)()
set_global_condition("hasAria", true)()
set_global_condition("leader", "Genoxd")()

registered_gambits = {

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("akila use ja", nil),
        },
        set_global_condition("useJA", true)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("akila stop ja", nil),
        },
        set_global_condition("useJA", false)
    ),
	
	Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("akila use 1hr", nil),
        },
        set_global_condition("use1Hr", true)
    ),
	
	Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("akila stop 1hr", nil),
        },
        set_global_condition("use1Hr", false)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Reraise"),
			Gambits.can_cast_spell_cond.cond("Reraise"),
        },
        use_command("Reraise", "me")
    ),
    
    Gambits.handle_bard_songs.cond("leader"),
    
    Gambits.multi_condition_trigger.cond(
        {
            Gambits.bundle_set_spell.cond("Carnage Elegy"),
            Gambits.bundle_set_target_to_leaders_target.cond(get_global_condition("leader")()),
            Gambits.leader_is_engaged.cond(get_global_condition("leader")()),
            Gambits.leader_target_changed_cond.cond(get_global_condition("leader")(), "a67745d9-210d-46b3-813c-2cd501ed9e0e"),
            Gambits.can_cast_spell_cond.cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
    ),
}