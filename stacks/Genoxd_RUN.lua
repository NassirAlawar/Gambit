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
    --         windower.send_command('input //send @others //bl tid <tid>')
    --     end)
    -- ),

    Gambits.multi_condition_trigger.cond(
        {
            Gambits.is_engaged.cond(),
            Gambits.tp_above_cond.cond(1000)
        },
        use_command("Savage Blade", "t")
    )
}