Gambits = include('gambit_requires')

set_global_condition("useJA", true)()
set_global_condition("use1Hr", true)()
set_global_condition("hasHonorMarch", true)()
set_global_condition("hasAria", true)()
set_global_condition("leaders", S{"Genoxd", "Soade", "Akila", "Tambur", "Tarurock", "Tankaru"})()
set_global_condition("leader", "Genoxd")()

set_global_condition("do_dummy_songs", true)()
set_global_condition("dummy_song_one", "Army's Paeon III")()
set_global_condition("dummy_song_two", "Army's Paeon II")()
set_global_condition("dummy_song_three", "Army's Paeon")()

registered_gambits = {

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_active_cond.cond("Doom", 1)
        },
        (function()
            windower.send_command('input /item "Holy Water" <me>;')
            return 3
        end)
    ),

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

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.buff_not_active_cond.cond("Reraise", 1),
	-- 		Gambits.can_cast_spell_cond.cond("Reraise"),
    --     },
    --     use_command("Reraise", "me")
    -- ),
    
    Gambits.handle_bard_songs_2.cond("leaders"),
    
    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.bundle_set_spell.cond("Carnage Elegy"),
    --         Gambits.bundle_set_target_to_leaders_target.cond(get_global_condition("leader")()),
    --         Gambits.leader_is_engaged.cond(get_global_condition("leader")()),
    --         Gambits.leader_target_changed_cond.cond(get_global_condition("leader")(), "a67745d9-210d-46b3-813c-2cd501ed9e0e"),
    --         Gambits.can_cast_spell_cond.cond("--bundle"),
    --     },
    --     use_command("--bundle", "--bundle")
    -- ),

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
    --         Gambits.tp_above_cond.cond(100),
    --         Gambits.is_engaged.cond(),
    --         Gambits.leader_target_is.cond("Akila", S{
    --             "Ghatjot",
    --             "Leshonn",
    --             "Skomora",
    --             "Degei",
    --             "Dhartok",
    --             "Gartell",
    --             "Triboulex",
    --             "Aita",
    --             "Aminon"
    --         }),
    --         Gambits.leader_target_changed_cond.cond("Akila", "a67745d9-210d-46b3-813c-2cd501ed9e0e")
    --     },
    --     use_command("Quickstep", "t")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.tp_above_cond.cond(100),
    --         Gambits.is_engaged.cond(),
    --         Gambits.leader_target_is.cond("Akila", S{
    --             "Ghatjot",
    --             "Leshonn",
    --             "Skomora",
    --             "Degei",
    --             "Dhartok",
    --             "Gartell",
    --             "Triboulex",
    --             "Aita",
    --             "Aminon"
    --         }),
    --         Gambits.leader_target_changed_cond.cond("Akila", "3e8a09ed-333e-4e64-8a08-ec53fe7ad4cb")
    --     },
    --     use_command("Box Step", "t")
    -- ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.main_weapon_type.cond("Sword"),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Savage Blade", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.main_weapon_name.cond("Mpu Gandring"),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Ruthless Stroke", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.main_weapon_type.cond("Dagger"),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Mordant Rime", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.leader_target_is.cond(get_global_condition("leader"), S{
                "Aminon"
            }),
            Gambits.ma_recast_ready_cond.cond("Absorb-TP"),
            Gambits.bundle_set_spell.cond("Absorb-TP"),
            Gambits.bundle_set_geo_spell_target.cond(get_global_condition("leader")),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),
}