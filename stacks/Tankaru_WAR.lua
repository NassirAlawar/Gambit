Gambits = include('gambit_requires')

registered_gambits = {
    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Savage Blade", "t")
    ),

    --Gambits.ja_recast_ready.cond("Meditate", use_command('Meditate', "me")),
    Gambits.ja_recast_ready.cond("Restraint", use_command('Restraint', "me")),
    Gambits.ja_recast_ready.cond("Warcry", use_command('Warcry', "me")),
    --Gambits.ja_recast_ready.cond("Berserk", use_command('Berserk', "me")),
    Gambits.ja_recast_ready.cond("Aggressor", use_command('Aggressor', "me")),
    
    --These all trigger whenever the recast is ready for the spell or ability
    --Gambits.ja_recast_ready.cond("Scavenge", use_command('Scavenge', "me"))
    --ja_recast_ready.ja_recast_ready("Warcry", use_command('Warcry', "me")),
    --ja_recast_ready.ja_recast_ready("Afflatus Misery", use_command('Afflatus Misery')),
    --ja_recast_ready.ja_recast_ready("Divine Caress", use_command('Divine Caress'))
    --ma_recast_ready.ma_recast_ready("Stoneskin", use_command('stoneskin')),
    --ma_recast_ready.ma_recast_ready("Cure IV", use_command('cure4', "me")),
    --ma_recast_ready.ma_recast_ready("Cure", use_command('cure', "self"))
}