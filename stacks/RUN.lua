Gambits = include('gambit_requires')

--[[
IC is in combat, OOC is out of combat 

On Buff Not Active 
* Elemental Buff x3 -OOC
* Crusade -OOC
* Temper -OOC

SJ DRK
On Recast 
* Absorb-TP -IC
* Absorb-STR -IC
* Absorb-VIT -IC
* Absorb-INT -IC
* Absorb-MND -IC

SJ BLU
On Recast 
* Geist Wail -IC or AoE
* Jettatura -IC
* Sheep Song -IC or AoE
* Soporific -IC or AoE
* Blank Gaze -IC

On Buff Lost 
* Cocoon

AoE tank mode needs to pull target then AoE anything that is targeting them and close enough for casting. AoE mode stops when there is nothing in range targeting them.

Do Not Engage mode needs to do all of the above even if not in combat. Might need a special gambit for this or an override for is_engaged.
]]

set_global_condition("runeElement", "thunder")()

registered_gambits = {

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.chat_match_part.cond("set", 0, nil),
            Gambits.chat_match_part.cond("rune", 1, nil),
            Gambits.chat_extract_part.cond(2, "g_cond_value", nil),
        },
        queue_use_commands(
            set_global_condition("runeElement", "--bundle"), 
            (function() windower.send_command('input /p Set rune element to '..tostring(get_global_condition("runeElement")())) return 0.1 end)
        )
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ma_recast_ready_cond.cond("Flash"),
            Gambits.can_cast_spell_cond.cond("Flash")
        },
        use_command("Flash", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Dimidiation", "t")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ma_recast_ready_cond.cond("Foil"),
            Gambits.can_cast_spell_cond.cond("Foil")
        },
        use_command("Foil", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Swordplay"),
            Gambits.can_use_ability_cond.cond()
        },
        use_command("Swordplay", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Pflug"),
            Gambits.can_use_ability_cond.cond(),
            Gambits.bundle_set_rune_by_element.cond("--global", "runeElement"),
            Gambits.buff_active_cond.cond("--bundle", 3)
        },
        use_command("Pflug", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Valiance"),
            Gambits.can_use_ability_cond.cond(),
            Gambits.buff_not_active_cond.cond("Vallation", 1),
            Gambits.bundle_set_rune_by_element.cond("--global", "runeElement"),
            Gambits.buff_active_cond.cond("--bundle", 3)
        },
        use_command("Valiance", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Vallation"),
            Gambits.can_use_ability_cond.cond(),
            Gambits.buff_not_active_cond.cond("Valiance", 1),
            Gambits.bundle_set_rune_by_element.cond("--global", "runeElement"),
            Gambits.buff_active_cond.cond("--bundle", 3)
        },
        use_command("Vallation", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Battuta"),
            Gambits.can_use_ability_cond.cond(),
            Gambits.bundle_set_rune_by_element.cond("--global", "runeElement"),
            Gambits.buff_active_cond.cond("--bundle", 3)
        },
        use_command("Battuta", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("Liement"),
            Gambits.can_use_ability_cond.cond(),
            Gambits.buff_not_active_cond.cond("Valiance", 1),
            Gambits.buff_not_active_cond.cond("Vallation", 1),
            Gambits.bundle_set_rune_by_element.cond("--global", "runeElement"),
            Gambits.buff_active_cond.cond("--bundle", 3)
        },
        use_command("Liement", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.ja_recast_ready_cond.cond("One for All"),
            Gambits.can_use_ability_cond.cond()
        },
        use_command("One for All", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.bundle_set_rune_by_element.cond("--global", "runeElement"),
            Gambits.buff_not_active_cond.cond("--bundle", 3),
            Gambits.ja_recast_ready_cond.cond("--bundle"),
            Gambits.can_use_ability_cond.cond()
        },
        use_command("--bundle", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Enmity Boost", 1),
            Gambits.ma_recast_ready_cond.cond("Crusade"),
            Gambits.can_cast_spell_cond.cond("Crusade")
        },
        use_command("Crusade", "me")
    ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Multi Strikes", 1),
            Gambits.ma_recast_ready_cond.cond("Temper"),
            Gambits.can_cast_spell_cond.cond("Temper")
        },
        use_command("Temper", "me")
    )
}