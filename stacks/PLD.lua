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
    --         windower.send_command('input //send @others //gs c partytarget '..target_info.id..';')
    --         windower.send_command('wait 1;input //send akila //gs c attack Genoxd')
    --         windower.send_command('wait 2;input //send soade //gs c attack Genoxd')
    --         windower.send_command('wait 3;input //send tambur //gs c attack Genoxd')
    --     end)
    -- ),

	Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Savage Blade", "t")
    ),
    
    --These all trigger whenever the recast is ready for the spell or ability
    --Gambits.ja_recast_ready.cond("Meditate", use_command('Meditate', "me"))
    --ja_recast_ready.ja_recast_ready("Warcry", use_command('Warcry', "me")),
    --ja_recast_ready.ja_recast_ready("Aggressor", use_command('Aggressor', "me")),
    --ja_recast_ready.ja_recast_ready("Afflatus Misery", use_command('Afflatus Misery')),
    --ja_recast_ready.ja_recast_ready("Divine Caress", use_command('Divine Caress'))
    --ma_recast_ready.ma_recast_ready("Stoneskin", use_command('stoneskin')),
    --ma_recast_ready.ma_recast_ready("Cure IV", use_command('cure4', "me")),
    --ma_recast_ready.ma_recast_ready("Cure", use_command('cure', "self"))
}