local gd = require('gambits/gambit_defines')
local M = {}

function timed_input(input_text, start_delay, repeat_delay)
    local next_run = 0
    local obj = {
        trigger_type = gd.trigger_types.timed,
        start_time = os.clock(),
        start_time = start_delay,
        repeat_time = repeat_delay,
        proc = (function()
            windower.send_command('input '..input_text)
            next_run = os.clock() + repeat_delay
        end),
        initalize_gambit = (function()
            next_run = os.clock() + start_delay
        end),
        should_proc = (function()
            return (os.clock() > next_run)
        end)
    }
    return obj
end

M.timed_input = timed_input

return M