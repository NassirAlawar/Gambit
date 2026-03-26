Gambits = include('gambit_requires')

set_global_condition("leader", "Genoxd")()

local cc_roll = "Chaos Roll"
local second_roll = "Samurai Roll"

registered_gambits = {

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

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.target_is.cond(S{
                "Ghatjot", 
                "Leshonn", 
                "Skomora",
                "Degei", 
                "Dhartok", 
                "Gartell",
                "Triboulex",
                "Aita",
                "Locus Colibri"
            }, false),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Savage Blade", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.target_is.cond(S{
                "Ghatjot", 
                "Leshonn", 
                "Skomora",
                "Degei", 
                "Dhartok", 
                "Gartell",
                "Triboulex",
                "Aita"
            }, false),
            Gambits.target_name_changed_cond.cond("Genoxd", "14dcce0b-2028-4872-9f27-e9e9b21c64b2"),
        },
        (function()
            windower.send_command('input //gs c sb')
            return 0.1
        end)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.target_is.cond(S{
                "Esurient Botulus"
            }, false),
            Gambits.target_name_changed_cond.cond("Genoxd", "14dcce0b-2028-4872-9f27-e9e9b21c64b2"),
        },
        (function()
            windower.send_command('input //gs c ra')
            return 0.1
        end)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.target_is.cond(S{
                "Aminon"
            }),
            Gambits.ma_recast_ready_cond.cond("Absorb-TP"),
            Gambits.bundle_set_spell.cond("Absorb-TP"),
            Gambits.bundle_set_spell_target.cond("t"),
            Gambits.can_cast_spell_cond.cond("--bundle", true),
        },
        use_command("--bundle", "--bundle")
    ),
}