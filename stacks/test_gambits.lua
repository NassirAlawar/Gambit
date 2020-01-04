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
    --chat_trigger.chat_trigger("Cure", use_command("cure4", "me")),
    --mct.multi_condition_trigger(
        --{
            --chat_match_cond.chat_match_cond("Haste", nil),
            --can_cast_spell_cond.can_cast_spell_cond("Haste"),
          --  buff_not_active_cond.buff_not_active_cond("Haste"),
        --},
      --  use_command("Haste", "me")
    --),
    mct.multi_condition_trigger(
        {
            chat_match_buff.chat_match_buff(nil),
            can_cast_spell_cond.can_cast_spell_cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
    ),
    --hpp_below_trigger.hpp_below_trigger(70, use_command("cure4", "me")),
    --hp_below_trigger.hp_below_trigger(1000, use_command("cure", "me")),
    
    --mct.multi_condition_trigger(
        --{
            --tp_above_cond.tp_above_cond(1000)
        --},
        --use_command("Savage Blade", "t")
    --),
    --mct.multi_condition_trigger(
      --  {
            --buff_not_active_cond.buff_not_active_cond("Aftermath: Lv.3"),
            ---tp_above_cond.tp_above_cond(3000)
        --},
        --use_command("Garland of Bliss", "t")
    --),
    --ja_recast_ready.ja_recast_ready("Berserk", use_command('Berserk', "me")),
    --ja_recast_ready.ja_recast_ready("Warcry", use_command('Warcry', "me")),
    --ja_recast_ready.ja_recast_ready("Aggressor", use_command('Aggressor', "me")),
    --ja_recast_ready.ja_recast_ready("Afflatus Misery", use_command('Afflatus Misery')),
    --ja_recast_ready.ja_recast_ready("Divine Caress", use_command('Divine Caress'))
    --ma_recast_ready.ma_recast_ready("Stoneskin", use_command('stoneskin')),
    --ma_recast_ready.ma_recast_ready("Cure IV", use_command('cure4', "me")),
    --ma_recast_ready.ma_recast_ready("Cure", use_command('cure', "self"))
}