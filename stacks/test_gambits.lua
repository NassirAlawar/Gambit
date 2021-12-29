local timed_input = require('gambits/timed_input')
local ja_recast_ready = require('gambits/ja_recast_ready')
local ma_recast_ready = require('gambits/ma_recast_ready')
local tp_trigger = require('gambits/tp_trigger')
local hp_below_trigger = require('gambits/hp_below_trigger')
local hpp_below_trigger = require('gambits/hpp_below_trigger')
local mct = require('gambits/multi_condition_trigger')
local chat_trigger = require('gambits/chat_trigger')
local tp_above_cond = require('gambits/conditions/tp_above_cond')
local buff_not_active_cond = require('gambits/conditions/buff_not_active_cond')
local buff_active_cond = require('gambits/conditions/buff_active_cond')
local can_cast_spell_cond = require('gambits/conditions/can_cast_spell_cond')
local chat_match_cond = require('gambits/conditions/chat_match_cond')
local chat_match_buff = require('gambits/conditions/chat_match_buff')

registered_gambits = {
    --If someone says "Cure" then cast cure 4 on <me>
    --chat_trigger.chat_trigger("Cure", use_command("cure4", "me")),
    
    --If someone says "Haste" and this character can cast haste and they do not have the haste buff active then cast haste on <me>
    --mct.multi_condition_trigger(
        --{
            --chat_match_cond.chat_match_cond("Haste", nil),
            --can_cast_spell_cond.can_cast_spell_cond("Haste"),
          --  buff_not_active_cond.buff_not_active_cond("Haste"),
        --},
      --  use_command("Haste", "me")
    --),
    
    --Complex trigger. This passes parameters between conditions using the "--bundle"
    --This will match any buff in chat and attempt to cast the highest tier available for tha buff on the speaker
    --Example: Bob says refresh in chat and this character is a level 99 RDM so Refresh III is cast
    mct.multi_condition_trigger(
        {
            --Check if the chat message contains a known buff that the player has access to. Pass nil to listen to anyone talking
            --Can pass a string to only listen to a certain player name such as "Bob"
            --This makes use of --bundles which allows condition checks to store and pass data between checks for multi condition triggers
            --If a spell is available that matches the buff this will store it inside the bundle
            chat_match_buff.chat_match_buff(nil),
            --Check if the character can cast the spell. "--bundle" is passed in to indicate that this condition should check the 
            --spell contained in the bundle and not the parameter passed in.
            --This will check the main/sj levels, recast times, status effects, and if the player is moving to determine if the spell can be cast.
            can_cast_spell_cond.can_cast_spell_cond("--bundle"),
        },
        --If all conditions pass then use the command, "--bundle" is passed in for parameter 1 to indicate that the command to use is stored in the bundle.
        --"--bundle" is passed in for parameter 2 to indicate that the target of the spell should be selected from the bundle.
        --valid targets include "me" and "self" to cast on <me>, "t" and "target" to cast on <t> and nil to use the default for action for the spell
        use_command("--bundle", "--bundle")
    ),
    
    --If this characters HP falls below 70% cast Cure IV on <me>
    --hpp_below_trigger.hpp_below_trigger(70, use_command("cure4", "me")),
    
    --If this characters HP falls below 1000 then cast Cure on <me>
    --hp_below_trigger.hp_below_trigger(1000, use_command("cure", "me")),
    
    --If TP is >= 1000 then use Savage Blade on the current <t>
    --mct.multi_condition_trigger(
        --{
            --tp_above_cond.tp_above_cond(1000)
        --},
        --use_command("Savage Blade", "t")
    --),
    
    --If the Aftermath: Lv.3 buff is not active and TP is >= 3000 then use Garland of Bliss on <t>
    --mct.multi_condition_trigger(
      --  {
            --buff_not_active_cond.buff_not_active_cond("Aftermath: Lv.3"),
            ---tp_above_cond.tp_above_cond(3000)
        --},
        --use_command("Garland of Bliss", "t")
    --),
    
    --These all trigger whenever the recast is ready for the spell or ability
    --ja_recast_ready.ja_recast_ready("Berserk", use_command('Berserk', "me")),
    --ja_recast_ready.ja_recast_ready("Warcry", use_command('Warcry', "me")),
    --ja_recast_ready.ja_recast_ready("Aggressor", use_command('Aggressor', "me")),
    --ja_recast_ready.ja_recast_ready("Afflatus Misery", use_command('Afflatus Misery')),
    --ja_recast_ready.ja_recast_ready("Divine Caress", use_command('Divine Caress'))
    --ma_recast_ready.ma_recast_ready("Stoneskin", use_command('stoneskin')),
    --ma_recast_ready.ma_recast_ready("Cure IV", use_command('cure4', "me")),
    --ma_recast_ready.ma_recast_ready("Cure", use_command('cure', "self"))
}