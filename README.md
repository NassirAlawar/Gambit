# Gambit

A rule-based automation addon for Final Fantasy XI (Windower). Define conditional "gambits" that automatically execute actions when a set of conditions are met — similar to the AI programming systems found in some other RPGs. Designed for multi-boxing, support automation, and intelligent behavior chains.

---

## Table of Contents

- [Installation](#installation)
- [Commands](#commands)
- [Configuration Files](#configuration-files)
- [Writing Gambits](#writing-gambits)
  - [Gambit Types (Triggers)](#gambit-types-triggers)
  - [Conditions](#conditions)
  - [Actions](#actions)
  - [The Bundle System](#the-bundle-system)
- [Conditions Reference](#conditions-reference)
- [Special Systems](#special-systems)
- [Examples](#examples)

---

## Installation

1. Place the `Gambit` folder in your Windower `addons/` directory.
2. Load the addon: `//lua load Gambit`
3. To auto-load, add `lua load Gambit` to your `Windower/scripts/init.txt`.

---

## Commands

```
//gambit start       Enable gambits
//gambit stop        Pause all gambits
//gb start           Shorthand versions work too
//gb stop
```

Gambits begin processing as soon as `start` is issued. Use `stop` to pause without unloading.

---

## Configuration Files

Gambits are defined in Lua files inside the `stacks/` folder. The addon searches for a config file in this priority order (first match wins):

| Priority | Filename |
|----------|----------|
| 1 | `CharacterName_JOB.lua` (e.g. `Bob_COR.lua`) |
| 2 | `CharacterName-JOB.lua` |
| 3 | `CharacterName_Corsair.lua` (full job name) |
| 4 | `CharacterName-Corsair.lua` |
| 5 | `CharacterName.lua` |
| 6 | `COR.lua` (job-only template) |
| 7 | `Corsair.lua` |
| 8 | `default.lua` |

Start by copying `stacks/test_gambits.lua` and renaming it to match your character and job.

### Config File Structure

```lua
-- stacks/MyChar_WHM.lua

-- These modules are available globally — require what you need
local mct   = require('gambits/multi_condition_trigger')
local hpp   = require('gambits/hpp_below_trigger')

local buff_not_active_cond = require('gambits/conditions/buff_not_active_cond')
local can_cast_spell_cond  = require('gambits/conditions/can_cast_spell_cond')

registered_gambits = {
    -- Put your gambits here
}
```

The only required export is the `registered_gambits` table. Each entry is a gambit constructed by one of the trigger functions below.

---

## Writing Gambits

### Gambit Types (Triggers)

Every gambit is built around a trigger type that determines *when* it fires.

#### Multi-Condition Trigger

The most flexible type. Fires when **all** listed conditions pass (AND logic).

```lua
local mct = require('gambits/multi_condition_trigger')

mct.multi_condition_trigger(
    { condition1, condition2, condition3 },
    action
)
```

Conditions are evaluated left to right. Evaluation stops at the first failure.

---

#### HP Below Trigger

Fires once when the player's HP drops to or below an absolute value.

```lua
local hp_below_trigger = require('gambits/hp_below_trigger')

hp_below_trigger.hp_below_trigger(500, use_command("cure", "me"))
```

---

#### HP% Below Trigger

Fires once when the player's HP percentage drops to or below the threshold.

```lua
local hpp_below_trigger = require('gambits/hpp_below_trigger')

hpp_below_trigger.hpp_below_trigger(70, use_command("cure4", "me"))
```

---

#### TP Trigger

Fires when TP reaches or exceeds the threshold.

```lua
local tp_trigger = require('gambits/tp_trigger')

tp_trigger.tp_trigger(1000, use_command("Savage Blade", "t"))
```

---

#### JA Recast Ready

Fires whenever a job ability comes off cooldown.

```lua
local ja_recast_ready = require('gambits/ja_recast_ready')

ja_recast_ready.ja_recast_ready("Berserk", use_command("Berserk", "me"))
```

---

#### MA Recast Ready

Fires whenever a magic spell comes off cooldown.

```lua
local ma_recast_ready = require('gambits/ma_recast_ready')

ma_recast_ready.ma_recast_ready("Stoneskin", use_command("stoneskin", "me"))
```

---

#### Timed Input

Executes a command on a repeating timer.

```lua
local timed_input = require('gambits/timed_input')

--                           command    start_delay  repeat_delay (seconds)
timed_input.timed_input("Berserk",     5,           180)
```

- `start_delay`: Seconds to wait before first execution.
- `repeat_delay`: Seconds between subsequent executions.

---

#### Chat Trigger

Fires when a specific message is received in party chat.

```lua
local chat_trigger = require('gambits/chat_trigger')

chat_trigger.chat_trigger("Cure", use_command("cure4", "me"))
```

For more powerful chat matching (partial text, buff recognition), use a Multi-Condition Trigger with chat conditions instead.

---

### Conditions

Conditions are imported individually and used inside Multi-Condition Triggers.

```lua
local tp_above_cond = require('gambits/conditions/tp_above_cond')

-- Use the condition in a gambit:
mct.multi_condition_trigger(
    { tp_above_cond.cond(1000) },
    use_command("Savage Blade", "t")
)
```

Each condition module exposes a `cond(...)` constructor. See the [Conditions Reference](#conditions-reference) for all available conditions.

---

### Actions

The most common action is `use_command`, which is available globally (no require needed).

```lua
use_command(command, target)
```

| Target value | In-game target |
|---|---|
| `"me"` or `"self"` | `<me>` |
| `"t"` or `"target"` | `<t>` |
| `nil` | Default target for the spell/ability |
| `"--bundle"` | Target stored in the bundle (see below) |

```lua
use_command("Cure IV", "me")           -- /ma "Cure IV" <me>
use_command("Savage Blade", "t")       -- /ws "Savage Blade" <t>
use_command("Berserk", nil)            -- /ja "Berserk"
use_command("--bundle", "--bundle")    -- Spell and target both from bundle
```

---

### The Bundle System

The bundle is a data-passing mechanism for Multi-Condition Triggers. Earlier conditions can store data (a spell name, a target, etc.) that later conditions and the final action can read.

Use `"--bundle"` as a parameter to tell a condition or action to look inside the bundle instead of using a literal value.

**Example: Cast the appropriate buff when asked in chat**

```lua
local mct              = require('gambits/multi_condition_trigger')
local chat_match_buff  = require('gambits/conditions/chat_match_buff')
local can_cast_spell_cond = require('gambits/conditions/can_cast_spell_cond')

mct.multi_condition_trigger(
    {
        -- Matches any known buff name in chat and stores the best available
        -- spell for it in the bundle. Pass nil to listen to any speaker,
        -- or pass "Bob" to only listen to a specific player.
        chat_match_buff.chat_match_buff(nil),

        -- Checks that the bundled spell can be cast right now (recast ready,
        -- enough MP, correct job level, not silenced, etc.)
        can_cast_spell_cond.can_cast_spell_cond("--bundle"),
    },
    -- Cast the bundled spell on the bundled target (the speaker)
    use_command("--bundle", "--bundle")
)
```

**Bundle-aware conditions:**

| Condition | What it stores |
|---|---|
| `chat_match_buff` | Best available spell for the buff mentioned; target = speaker |
| `chat_match_heal` | Best available heal spell mentioned; target = speaker |
| `bundle_set_spell` | Manually store a specific spell |
| `bundle_set_spell_target` | Manually store a target |
| `bundle_set_target_to_leaders_target` | Target = leader's current target |
| `bundle_set_brd_spell` | Auto-select the best bard song |
| `bundle_set_rune_by_element` | Auto-select rune based on element |
| `bundle_pick_highest_tier_buff` | Select highest available tier of a buff |
| `bundle_find_unclaimed_target` | Find an unclaimed nearby mob |

---

## Conditions Reference

### Vitals

```lua
local hpp_below_cond = require('gambits/conditions/hpp_below_cond')
```

| Condition module | `cond(...)` | Description |
|---|---|---|
| `hp_below_cond` | `cond(amount)` | Player HP <= amount |
| `hpp_below_cond` | `cond(percent)` | Player HP% <= percent |
| `mp_below_cond` | `cond(amount)` | Player MP <= amount |
| `mpp_below_cond` | `cond(percent)` | Player MP% <= percent |
| `tp_above_cond` | `cond(amount)` | Player TP >= amount |
| `tp_below_cond` | `cond(amount)` | Player TP < amount |
| `target_hpp_below_cond` | `cond(percent)` | Current target HP% <= percent |
| `pet_hpp_below_cond` | `cond(percent)` | Pet HP% <= percent |
| `pet_hpp_above_cond` | `cond(percent)` | Pet HP% >= percent |

---

### Buffs & Debuffs

| Condition module | `cond(...)` | Description |
|---|---|---|
| `buff_active_cond` | `cond(buff_name, count)` | Player has buff (count = stacks, default 1) |
| `buff_not_active_cond` | `cond(buff_name, count)` | Player does NOT have buff |
| `buff_active_on_party_member_cond` | `cond(name, buff_name)` | Party member has buff |
| `buff_not_active_on_party_member_cond` | `cond(name, buff_name)` | Party member lacks buff |
| `debuff_active_on_player_cond` | `cond(debuff_name)` | Player has debuff |
| `debuff_active_on_party_member_cond` | `cond(name, debuff_name)` | Party member has debuff |

---

### Abilities & Spells

| Condition module | `cond(...)` | Description |
|---|---|---|
| `ja_recast_ready_cond` | `cond(ability_name)` | Job ability is off cooldown |
| `ma_recast_ready_cond` | `cond(spell_name)` | Spell is off cooldown |
| `can_cast_spell_cond` | `cond(spell_name)` | Can cast now: checks level, recast, MP, status effects, movement, range, and zone restrictions. Pass `"--bundle"` to check the bundled spell. |

---

### Engagement & Movement

| Condition module | `cond(...)` | Description |
|---|---|---|
| `is_engaged` | `cond()` | Player is in combat |
| `is_not_moving` | `cond()` | Player is not moving |
| `is_in_range` | `cond(spell_name)` | Target is in range for spell |
| `is_ja_in_range` | `cond(ability_name)` | Target is in range for ability |
| `leader_is_engaged` | `cond()` | Group leader is in combat |
| `leader_is_not_engaged` | `cond()` | Group leader is NOT in combat |

---

### Targeting

| Condition module | `cond(...)` | Description |
|---|---|---|
| `is_target_valid` | `cond()` | Player has a valid target |
| `target_is` | `cond(name_or_set, invert)` | Target name matches (pass a set `S{...}` for multiple names; set `invert=true` to negate) |
| `leader_target_is` | `cond(name_or_set)` | Leader's target matches |
| `target_name_changed_cond` | `cond(leader_name, uuid)` | Player's target changed since last check |
| `leader_target_changed_cond` | `cond(leader_name, uuid)` | Leader's target changed since last check |

---

### Pets

| Condition module | `cond(...)` | Description |
|---|---|---|
| `has_pet_cond` | `cond()` | Player has an active pet |
| `does_not_have_pet_cond` | `cond()` | Player has no pet |
| `pet_in_range_to_target_cond` | `cond()` | Pet can reach current target |
| `pet_not_in_range_to_target_cond` | `cond()` | Pet cannot reach current target |

---

### Chat

| Condition module | `cond(...)` | Description |
|---|---|---|
| `chat_match_cond` | `cond(text, speaker)` | Exact chat match. Pass `nil` for speaker to match anyone. |
| `chat_match_part_cond` | `cond(text, speaker)` | Partial chat match |
| `chat_match_buff` | `cond(speaker)` | Chat contains a known buff name; stores best spell in bundle |
| `chat_match_heal` | `cond(speaker)` | Chat contains a known heal spell |
| `chat_extract_part_cond` | `cond(position)` | Extract a word from the chat message by position |
| `chat_translate_buff` | `cond()` | Translate the buffname from the chat message |

---

### Weapons

| Condition module | `cond(...)` | Description |
|---|---|---|
| `main_weapon_type_cond` | `cond(type)` | Main hand weapon type matches |
| `main_weapon_name_cond` | `cond(name)` | Main hand weapon name matches |

---

### Global State

Useful for coordinating behavior across multiple gambits or characters.

```lua
local check_global_equals = require('gambits/conditions/check_global_equals')

-- In an action, set a global variable:
set_global_condition("mode", "healing")()

-- In a condition, check it:
check_global_equals.cond("mode", "healing")         -- true when equal
check_global_equals.cond("mode", "healing", true)   -- true when NOT equal (inverted)
```

---

### One-Per-Fight

Ensures a gambit only fires once per combat encounter. Requires a unique UUID string to track state.

```lua
local once_per_fight = require('gambits/conditions/once_per_fight_cond')

once_per_fight.cond("550e8400-e29b-41d4-a716-446655440000")
```

Generate any unique string — you can use an online UUID generator or just make up a unique identifier.

---

## Special Systems

### Smart Healing (`handle_cures`)

An intelligent healing system for WHM/support characters. Rather than casting a fixed spell, it surveys the party, picks the optimal target and cure tier, and handles AoE vs. single-target decisions automatically.

```lua
local handle_cures = require('gambits/handle_cures')

registered_gambits = {
    handle_cures.cond(),
}
```

Behavior:
- AoE cure (Curaga) when multiple party members are critically low
- Single-target priority on the lowest HP member
- Falls back to `Full Cure` when caster MP is below 80
- Requires WHM main job or subjob for Curaga access

---

### Bard Song Automation (`handle_bard_songs_2`)

A chat-driven song system for Bard. Party members issue commands in party chat to queue songs, which the BRD character then casts automatically. Handles Pianissimo for off-self targets, dummy song insertion, and automatic re-cast timing.

#### Setup

```lua
local handle_bard_songs_2 = require('gambits/handle_bard_songs_2')

registered_gambits = {
    -- Pass the name of a global variable that holds the leader's name (or nil for anyone).
    -- Only that player's chat commands will be processed.
    handle_bard_songs_2.cond("leaderName"),
}
```

The `leader_var` argument is the **name of a global variable** (set via `set_global_condition`) that contains the leader's character name or a set of names. Pass `nil` to respond to any speaker.

#### Global Variables

These globals control behavior and should be set in your config or via a gambit before using bard songs:

| Variable | Type | Description |
|---|---|---|
| `useJA` | boolean | Whether `ja` in a sing command actually uses Nightingale/Troubadour/Marcato |
| `use1Hr` | boolean | Whether `1hr` in a sing command actually uses Clarion Call + Soul Voice |
| `hasHonorMarch` | boolean | Set to `true` if the BRD has access to Honor March (instrument-gated) |
| `hasAria` | boolean | Set to `true` if the BRD has access to Aria of Passion |
| `do_dummy_songs` | boolean | Whether to insert dummy songs between real songs to push old buffs off |
| `dummy_song_one` | string | Spell name for the 2nd-slot dummy song |
| `dummy_song_two` | string | Spell name for the 3rd-slot dummy song |
| `dummy_song_three` | string | Spell name for the 4th-slot dummy song |

#### Chat Commands

All commands are spoken in **party chat**.

---

**Sing songs once:**
```
sing [songs...] [target] [ja] [1hr]
```
Queues up to 5 songs for a single cast cycle.

---

**Keep singing (auto-repeat):**
```
keep singing [songs...] [target] [ja] [1hr]
```
Queues songs and automatically re-casts them before they expire. The system calculates recast timing from song duration + gear bonus. Max 4 songs (5 with `1hr`).

---

**Stop all songs:**
```
clear songs
```
Clears both the active cast queue and any repeating song cycles.

---

**Check what's queued:**
```
which songs
```
Prints each active repeating song cycle to party chat, including what songs are in it, the target, and time until next cast.

---

#### Parameters for sing / keep singing

| Parameter | Description |
|---|---|
| Song keyword (e.g. `march`, `minuet`) | The buff type to sing. Automatically selects the highest available tier. Case-insensitive. |
| Character name (e.g. `Bob`) | Cast songs on that player instead of self (uses Pianissimo automatically). |
| `ja` | Prepend Nightingale, Troubadour, and Marcato before singing (requires `useJA = true`). |
| `1hr` | Use Clarion Call and Soul Voice before singing (requires `use1Hr = true`). |

Multiple songs and modifiers can be combined in any order:

```
keep singing march minuet ja Bob
```
→ Use Nightingale/Troubadour/Marcato, then Pianissimo + highest March tier on Bob, then Pianissimo + highest Minuet tier on Bob. Auto-repeats.

```
sing ballad madrigal 1hr
```
→ Clarion Call + Soul Voice, then Ballad and Madrigal on self. One time only.

#### Dummy Songs

When a BRD needs to overwrite old songs (e.g. to land 2× March), dummy songs fill the intermediate slots to push the old buff off the target's song list. Set `do_dummy_songs = true` and configure the dummy spell names:

```lua
set_global_condition("do_dummy_songs", true)()
set_global_condition("dummy_song_one",   "Foe Lullaby")()
set_global_condition("dummy_song_two",   "Foe Lullaby II")()
set_global_condition("dummy_song_three", "Horde Lullaby")()
```

---

### Corsair Roll Automation (`handle_cor_rolls`)

Manages Corsair roll selection and Double-Up logic based on current targets and party needs.

---

## Examples

### Warrior: Use abilities on cooldown

```lua
local ja_recast_ready = require('gambits/ja_recast_ready')

registered_gambits = {
    ja_recast_ready.ja_recast_ready("Berserk",    use_command("Berserk",    "me")),
    ja_recast_ready.ja_recast_ready("Warcry",     use_command("Warcry",     "me")),
    ja_recast_ready.ja_recast_ready("Aggressor",  use_command("Aggressor",  "me")),
}
```

---

### White Mage: Self-cure when HP is low

```lua
local hpp_below_trigger = require('gambits/hpp_below_trigger')

registered_gambits = {
    hpp_below_trigger.hpp_below_trigger(50, use_command("cure4", "me")),
}
```

---

### Any job: Cast buff when asked in party chat

```lua
local mct             = require('gambits/multi_condition_trigger')
local chat_match_buff = require('gambits/conditions/chat_match_buff')
local can_cast_spell  = require('gambits/conditions/can_cast_spell_cond')

registered_gambits = {
    mct.multi_condition_trigger(
        {
            chat_match_buff.chat_match_buff(nil),
            can_cast_spell.can_cast_spell_cond("--bundle"),
        },
        use_command("--bundle", "--bundle")
    ),
}
```

---

### Melee DPS: Weaponskill with conditions

```lua
local mct                 = require('gambits/multi_condition_trigger')
local tp_above_cond       = require('gambits/conditions/tp_above_cond')
local buff_not_active_cond = require('gambits/conditions/buff_not_active_cond')
local is_engaged          = require('gambits/conditions/is_engaged')

registered_gambits = {
    -- Only use Garland of Bliss to build Aftermath: Lv.3 (don't waste if already up)
    mct.multi_condition_trigger(
        {
            is_engaged.cond(),
            tp_above_cond.cond(3000),
            buff_not_active_cond.cond("Aftermath: Lv.3", 1),
        },
        use_command("Garland of Bliss", "t")
    ),
}
```

---

### Corsair: Dance on specific enemies, once per fight

```lua
local mct              = require('gambits/multi_condition_trigger')
local is_engaged       = require('gambits/conditions/is_engaged')
local tp_above_cond    = require('gambits/conditions/tp_above_cond')
local is_in_range      = require('gambits/conditions/is_in_range')
local target_is        = require('gambits/conditions/target_is')
local ja_recast_ready  = require('gambits/conditions/ja_recast_ready_cond')
local once_per_fight   = require('gambits/conditions/once_per_fight_cond')

registered_gambits = {
    mct.multi_condition_trigger(
        {
            is_engaged.cond(),
            tp_above_cond.cond(100),
            is_in_range.cond("Box Step"),
            target_is.cond(S{ "BossA", "BossB", "BossC" }, false),
            ja_recast_ready.cond("Box Step"),
            once_per_fight.cond("a1b2c3d4-e5f6-7890-abcd-ef1234567890"),
        },
        use_command("Box Step", "t")
    ),
}
```

---

## Tips

- **Order matters**: Conditions are checked left to right. Put cheap/fast checks (like `is_engaged`) before expensive ones (like range checks).
- **GCD**: After an action fires, the cooldown before gambits run again depends on what was used. The addon intercepts the outgoing packet to set the delay: spell casts use ~3.1 seconds, job abilities and weaponskills use ~1.1 seconds.
- **Multiple gambits**: The addon processes the `registered_gambits` list in order. The first gambit whose conditions all pass will execute, then the GCD kicks in.
- **UUIDs for `once_per_fight`**: Each unique `once_per_fight` condition needs its own UUID so different gambits can independently track their per-fight state.
- **Testing**: Use the commented-out examples in `stacks/test_gambits.lua` as a reference when building new gambits.
