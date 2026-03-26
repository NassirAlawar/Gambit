Gambits = include('gambit_requires')

registered_gambits = {

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.target_is.cond(S{
                "Locus Colibri"
            }, false),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Savage Blade", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Warcry"),
            Gambits.target_is.cond(S{
                "Locus Colibri"
            }, false),
        },
        use_command("Warcry", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Berserk"),
            Gambits.target_is.cond(S{
                "Locus Colibri"
            }, false),
        },
        use_command("Berserk", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Restraint"),
            Gambits.target_is.cond(S{
                "Locus Colibri"
            }, false),
        },
        use_command("Restraint", "me")
    ),

    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.buff_not_active_cond.cond("Invisible", 1),
    --         Gambits.buff_not_active_cond.cond("Sneak", 1),
    --         Gambits.buff_not_active_cond.cond("Hasso", 1),
    --         Gambits.ja_recast_ready_cond.cond("Hasso"),
    --     },
    --     use_command("Hasso", "me")
    -- ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Warcry"),
            Gambits.target_is.cond(S{
                "Leshonn", 
                "Gartell",
                "Ghatjot", 
                "Skomora",
                "Degei", 
                "Dhartok", 
                "Triboulex",
                "Aita",
            }, false),
        },
        use_command("Warcry", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Mighty Strikes"),
            Gambits.ja_recast_ready_cond.cond("Brazen Rush"),
            Gambits.target_is.cond(S{
                "Gartell",
                "Aita",
            }, false),
        },
        queue_use_commands(
            use_command("Mighty Strikes", "me"),
            use_command("Brazen Rush", "me")
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.target_is.cond(S{ 
                "Leshonn", 
                "Gartell",
            }, false),
            Gambits.target_name_changed_cond.cond("Genoxd", "14dcce0b-2028-4872-9f27-e9e9b21c64b2"),
        },
        (function()
            windower.send_command('input //gs c pole')
            return 0.1
        end)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.target_is.cond(S{ 
                "Ghatjot", 
                "Skomora",
                "Degei", 
                "Dhartok", 
                "Triboulex",
                "Aita",
            }, false),
            Gambits.target_name_changed_cond.cond("Genoxd", "14dcce0b-2028-4872-9f27-e9e9b21c64b2"),
        },
        (function()
            windower.send_command('input //gs c gaxe')
            return 0.1
        end)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.target_is.cond(S{ 
                "Gartell",
            }, false),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Impulse Drive", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.target_is.cond(S{ 
                "Leshonn",
            }, false),
            Gambits.tp_above_cond.cond(1550)
        },
        use_command("Impulse Drive", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.target_is.cond(S{
                "Aita",
            }, false),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Upheaval", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.target_is.cond(S{
                "Ghatjot", 
                "Skomora",
                "Degei", 
                "Dhartok", 
                "Triboulex",
            }, false),
            Gambits.tp_above_cond.cond(1550)
        },
        use_command("Upheaval", "t")
    ),
    
    -- Gambits.multi_condition_trigger.cond(
    --     {
    --         Gambits.is_engaged.cond(),
    --         Gambits.tp_above_cond.cond(1000)
    --     },
    --     use_command("Upheaval", "t")
    --     --use_command("Shield Break", "t")
    -- ),

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

    --Gambits.ja_recast_ready.cond("Restraint", use_command('Restraint', "me")),
    --Gambits.ja_recast_ready.cond("Retaliation", use_command('Retaliation', "me")),
    -- Gambits.ja_recast_ready.cond("Meditate", use_command('Meditate', "me")),
    -- Gambits.ja_recast_ready.cond("Warcry", use_command('Warcry', "me")),
    --Gambits.ja_recast_ready.cond("Berserk", use_command('Berserk', "me")),
    
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