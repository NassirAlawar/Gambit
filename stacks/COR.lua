Gambits = include('gambit_requires')

registered_gambits = {

    -- if spell.value ~= nil and spell.type == 'CorsairRoll' then
    --     lastCorsairRollValue = tonumber(spell.value)
    -- end


	Gambits.multi_condition_trigger.cond(
        {
            Gambits.buff_not_active_cond.cond("Hasso")
        },
        use_command("Hasso", "me")
    ),
}