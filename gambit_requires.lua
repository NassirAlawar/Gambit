-- All requires go here for ease of importing
local Gambits = {
    timed_input = include('gambits/timed_input'),
    ja_recast_ready = include('gambits/ja_recast_ready'),
    ma_recast_ready = include('gambits/ma_recast_ready'),
    tp_trigger = include('gambits/tp_trigger'),
    hp_below_trigger = include('gambits/hp_below_trigger'),
    hpp_below_trigger = include('gambits/hpp_below_trigger'),
    multi_condition_trigger = include('gambits/multi_condition_trigger'),
    chat_trigger = include('gambits/chat_trigger'),
    tp_above_cond = include('gambits/conditions/tp_above_cond'),
    buff_not_active_cond = include('gambits/conditions/buff_not_active_cond'),
    buff_active_cond = include('gambits/conditions/buff_active_cond'),
    can_cast_spell_cond = include('gambits/conditions/can_cast_spell_cond'),
    chat_match_cond = include('gambits/conditions/chat_match_cond'),
    chat_match_buff = include('gambits/conditions/chat_match_buff'),
    pet_in_range_to_target = include('gambits/conditions/pet_in_range_to_target_cond'),
    pet_not_in_range_to_target = include('gambits/conditions/pet_not_in_range_to_target_cond'),
    pet_in_range_to_target = include('gambits/conditions/pet_in_range_to_target_cond'),
    ja_recast_ready_cond = include('gambits/conditions/ja_recast_ready_cond'),
    does_not_have_pet = include('gambits/conditions/does_not_have_pet_cond'),
    bundle_set_spell = include('gambits/conditions/bundle_set_spell'),
    bundle_set_geo_spell_target = include('gambits/conditions/bundle_set_geo_spell_target'),
    leader_target_changed_cond = include('gambits/conditions/leader_target_changed_cond'),
    has_pet = include('gambits/conditions/has_pet_cond'),
    check_global_equals = include('gambits/conditions/check_global_equals'),
    is_engaged = include('gambits/conditions/is_engaged'),
    leader_is_engaged = include('gambits/conditions/leader_is_engaged'),
    pet_hpp_below = include('gambits/conditions/pet_hpp_below_cond'),
    pet_hpp_above = include('gambits/conditions/pet_hpp_above_cond'),
    chat_match_part = include('gambits/conditions/chat_match_part_cond'),
    chat_extract_part = include('gambits/conditions/chat_extract_part_cond'),
    bundle_set_spell_target = include('gambits/conditions/bundle_set_spell_target'),
    bundle_set_brd_spell = include('gambits/conditions/bundle_set_brd_spell'),
    handle_bard_songs = include('gambits/handle_bard_songs'),
    bundle_set_target_to_leaders_target = include('gambits/conditions/bundle_set_target_to_leaders_target'),
    bundle_pick_highest_tier_buff = include('gambits/conditions/bundle_pick_highest_tier_buff'),
    chat_translate_buff = include('gambits/conditions/chat_translate_buff'),
    target_hpp_below = include('gambits/conditions/target_hpp_below_cond'),
    once_per_fight = include('gambits/conditions/once_per_fight_cond')
}

return Gambits