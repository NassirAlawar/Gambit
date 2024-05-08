Gambits = include('gambit_requires')

registered_gambits = {

	Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Hasso")
        },
        use_command("Hasso", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Aftermath: Lv.3"),
            Gambits.tp_above_cond.cond(3000)
        },
        use_command("Tachi: Fudo", "t")
    ),
	
	Gambits.multi_condition_trigger.cond(
        {
			Gambits.buff_active_cond.cond("Aftermath: Lv.3"),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Tachi: Fudo", "t")
    ),
    
    --These all trigger whenever the recast is ready for the spell or ability
    Gambits.ja_recast_ready.cond("Meditate", use_command('Meditate', "me"))
    --ja_recast_ready.ja_recast_ready("Warcry", use_command('Warcry', "me")),
    --ja_recast_ready.ja_recast_ready("Aggressor", use_command('Aggressor', "me")),
    --ja_recast_ready.ja_recast_ready("Afflatus Misery", use_command('Afflatus Misery')),
    --ja_recast_ready.ja_recast_ready("Divine Caress", use_command('Divine Caress'))
    --ma_recast_ready.ma_recast_ready("Stoneskin", use_command('stoneskin')),
    --ma_recast_ready.ma_recast_ready("Cure IV", use_command('cure4', "me")),
    --ma_recast_ready.ma_recast_ready("Cure", use_command('cure', "self"))
}