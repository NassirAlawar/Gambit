
Gambits = include('gambit_requires')

registered_gambits = {

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.has_pet.cond(),
            Gambits.once_per_fight.cond("a2b8a469-50ee-4a63-961c-08ccf61d0a45")
        },
        -- (function()
        --     local target_info = windower.ffxi.get_mob_by_target('t')
        --     if type(target_info) ~= 'table' or target_info.id == nil then
        --         return
        --     end
        --     windower.send_command('input //send @others //bl tid <tid>')
        -- end)
        use_command("Assault", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.mp_below_cond.cond(500),
			Gambits.tp_above_cond.cond(1000)
        },
        use_command("Spirit Taker", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
			Gambits.tp_above_cond.cond(1500)
        },
        use_command("Oshala", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.does_not_have_pet.cond(),
        },
        use_command('Ifrit', "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.has_pet.cond(),
            Gambits.buff_not_active_cond.cond("Avatar's Favor", 1),
        },
        use_command("Avatar's Favor", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.has_pet.cond(),
            Gambits.buff_not_active_cond.cond("Astral Flow", 1),
            Gambits.ja_recast_ready_cond.cond("Astral Flow"),
        },
        use_command("Astral Flow", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.has_pet.cond(),
            Gambits.buff_not_active_cond.cond("Astral Conduit", 1),
            Gambits.ja_recast_ready_cond.cond("Astral Conduit"),
        },
        use_command("Astral Conduit", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Hasso"),
            Gambits.buff_not_active_cond.cond("Hasso", 1),
        },
        use_command("Hasso", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Berserk"),
        },
        use_command("Berserk", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Warcry"),
            Gambits.buff_not_active_cond.cond("Warcry", 1),
        },
        use_command("Warcry", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Blood Pact: Rage")
        },
        use_command('Flaming Crush', "t")
    ),
    
    
    --These all trigger whenever the recast is ready for the spell or ability
    --Gambits.ja_recast_ready.cond("Blood Pact: Rage", use_command('Flaming Crush', "t"))
    --ja_recast_ready.ja_recast_ready("Warcry", use_command('Warcry', "me")),
    --ja_recast_ready.ja_recast_ready("Aggressor", use_command('Aggressor', "me")),
    --ja_recast_ready.ja_recast_ready("Afflatus Misery", use_command('Afflatus Misery')),
    --ja_recast_ready.ja_recast_ready("Divine Caress", use_command('Divine Caress'))
    --ma_recast_ready.ma_recast_ready("Stoneskin", use_command('stoneskin')),
    --ma_recast_ready.ma_recast_ready("Cure IV", use_command('cure4', "me")),
    --ma_recast_ready.ma_recast_ready("Cure", use_command('cure', "self"))
}