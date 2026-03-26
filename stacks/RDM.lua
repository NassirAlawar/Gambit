Gambits = include('gambit_requires')

registered_gambits = {

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.once_per_fight.cond("a2b8a469-50ee-4a63-961c-08ccf61d0a45")
    --     },
    --     (function()
    --         local target_info = windower.ffxi.get_mob_by_target('t')
    --         if type(target_info) ~= 'table' or target_info.id == nil then
    --             return
    --         end
    --         windower.send_command('input //send @others //bl tid <tid>')
    --     end)
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.buff_not_active_cond.cond("Composure", 1),
    --     },
    --     use_command("Composure", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.buff_not_active_cond.cond("Multi Strikes", 1),
    --         Gambits.can_cast_spell_cond.cond("Temper II")
    --     },
    --     use_command("Temper II", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.buff_not_active_cond.cond("Enblizzard", 1),
    --         Gambits.can_cast_spell_cond.cond("Enblizzard")
    --     },
    --     use_command("Enblizzard", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.buff_not_active_cond.cond("Refresh", 2),
    --         Gambits.can_cast_spell_cond.cond("Refresh III")
    --     },
    --     use_command("Refresh III", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.buff_not_active_cond.cond("Haste", 1),
    --         Gambits.can_cast_spell_cond.cond("Haste II")
    --     },
    --     use_command("Haste II", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.can_cast_spell_cond.cond("Haste II"),
    --         Gambits.is_buff_missing_on_party_member.cond(S{"Genoxd", "Akila", "Tarurock", "Tankaru", "Tambur"}, "Haste"),
    --         Gambits.bundle_set_spell.cond("Haste II"),
    --         Gambits.can_cast_spell_cond.cond("--bundle", true),
    --         Gambits.is_target_valid.cond("--bundle", "--bundle")
    --     },
    --     use_command("--bundle", "--bundle")
    -- ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Black Halo", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.tp_above_cond.cond(100),
            Gambits.is_in_range.cond("Box Step"),
            Gambits.target_is.cond(S{
                "Ghatjot", 
                "Leshonn", 
                "Skomora",
                "Degei", 
                "Dhartok", 
                "Gartell",
                "Triboulex",
                "Aita",
                "Belaboring Wasp"
            }, false),
            Gambits.ja_recast_ready_cond.cond("Box Step"),
            Gambits.once_per_fight.cond("7cfc82f2-45b4-4771-9143-e00947b03b67")
        },
        use_command("Box Step", "t")
    ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.buff_not_active_cond.cond("Composure", 1)
    --     },
    --     use_command("Composure", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.can_cast_spell_cond.cond("Refresh III"),
    --         Gambits.buff_not_active_cond.cond("Refresh", 1)
    --     },
    --     use_command("Refresh III", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.can_cast_spell_cond.cond("Refresh III"),
    --         Gambits.buff_not_active_on_party_member_cond.cond("Tambur", "Refresh", 1)
    --     },
    --     use_command("Refresh III", "Tambur")
    -- ),

    -- -- Gambits.multi_condition_trigger.cond(
    -- --     {
    -- --         Gambits.ma_recast_ready_cond.cond("Dia"),
    -- --         Gambits.can_cast_spell_cond.cond("Dia")
    -- --     },
    -- --     use_command("Dia", "t")
    -- -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.can_cast_spell_cond.cond("Haste II"),
    --         Gambits.buff_not_active_cond.cond("Haste", 1)
    --     },
    --     use_command("Haste II", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.can_cast_spell_cond.cond("Haste II"),
    --         Gambits.buff_not_active_on_party_member_cond.cond("Akila", "Haste", 1)
    --     },
    --     use_command("Haste II", "Akila")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.can_cast_spell_cond.cond("Temper II"),
    --         Gambits.buff_not_active_cond.cond("Multi Strikes", 1)
    --     },
    --     use_command("Temper II", "me")
    -- ),

    -- --Gambits.ma_recast_ready.cond("Barstone", use_command('Barstone')),
    -- --Gambits.ma_recast_ready.cond("Barfire", use_command('Barfire')),

	-- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.can_cast_spell_cond.cond("Enblizzard"),
    --         Gambits.buff_not_active_cond.cond("Enblizzard", 1)
    --     },
    --     use_command("Enblizzard", "me")
    -- ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.can_cast_spell_cond.cond("Gain-STR"),
    --         Gambits.buff_not_active_cond.cond("STR Boost", 1)
    --     },
    --     use_command("Gain-STR", "me")
    -- ),
    
    --These all trigger whenever the recast is ready for the spell or ability
    --Gambits.ja_recast_ready.cond("Scavenge", use_command('Scavenge', "me"))
    --ja_recast_ready.ja_recast_ready("Warcry", use_command('Warcry', "me")),
    --ja_recast_ready.ja_recast_ready("Aggressor", use_command('Aggressor', "me")),
    --ja_recast_ready.ja_recast_ready("Afflatus Misery", use_command('Afflatus Misery')),
    --ja_recast_ready.ja_recast_ready("Divine Caress", use_command('Divine Caress'))
    --ma_recast_ready.ma_recast_ready("Stoneskin", use_command('stoneskin')),
    --ma_recast_ready.ma_recast_ready("Cure IV", use_command('cure4', "me")),
    --ma_recast_ready.ma_recast_ready("Cure", use_command('cure', "self"))
}