Gambits = include('gambit_requires')

local should_1hr = true

--local cc_roll = "Corsair's Roll"
--local second_roll = "Chaos Roll"

--local cc_roll = "Tactician's Roll"

-- local cc_roll = "Chaos Roll"
-- local second_roll = "Samurai Roll"

-- local cc_roll = "Fighter's Roll"
-- local second_roll = "Samurai Roll"

local cc_roll = "Gallant's Roll"
local second_roll = "Caster's Roll"

-- local cc_roll = "Beast Roll"
--local second_roll = "Chaos Roll"

-- local cc_roll = "Corsair's Roll"
-- local second_roll = "Wizard's Roll"

--local cc_roll = "Wizard's Roll"
--local second_roll = "Evoker's Roll"

-- local cc_roll = "Rogue's Roll"
-- local second_roll = "Tactician's Roll"

-- local cc_roll = "Corsair's Roll"
-- local second_roll = "Fighter's Roll"

set_global_condition("should_cc", false)()

registered_gambits = {

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_cond.cond("Cutting Cards", nil),
        },
        (function()
            set_global_condition("should_cc", true)()
            return 0.1
        end)
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.check_global_equals.cond("should_cc", true, false),
            Gambits.ja_recast_ready_cond.cond("Cutting Cards"),
        },
        queue_use_commands(
            use_command("Cutting Cards", "Akila"),
            use_command("Wildcard", "me"),
            (function()
                set_global_condition("should_cc", false)()
                return 0.1
            end)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond(cc_roll, 1),
            Gambits.ja_recast_ready_cond.cond("Crooked Cards"),
        },
        use_command("Crooked Cards", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.ja_recast_ready_cond.cond("Phantom Roll"),
            Gambits.buff_not_active_cond.cond(cc_roll, 1),
        },
        use_command(cc_roll, "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.ja_recast_ready_cond.cond("Phantom Roll"),
            Gambits.buff_not_active_cond.cond(second_roll, 1),
        },
        use_command(second_roll, "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.ja_recast_ready_cond.cond("Random Deal"),
        },
        use_command("Random Deal", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Savage Blade", "t")
    ),
}