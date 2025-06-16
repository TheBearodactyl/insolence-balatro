local function func_interval(interval, func, immediate)
    local timer = {
        interval = interval,
        func = func,
        last_execution = os.time(),
        accumulated_time = 0,
        running = 0
    }

    function timer.update(dt)
        if not timer.running then return end

        timer.accumulated_time = timer.accumulated_time + dt

        local curr_time = os.time()

        if curr_time - timer.last_execution >= timer.interval then
            timer.accumulated_time = 0
            timer.last_execution = curr_time
            timer.func()
        end
    end

    function timer.start()
        timer.running = true
        timer.last_execution = os.time()
    end

    function timer.stop()
        timer.running = false
    end

    if immediate then
        timer.func()
    end

    return timer
end

local dollars_timer = func_interval(3, function()
    ease_dollars(5, true)
end, false)

SMODS.Joker({
    key = "nami",
    rarity = "strawhat",
    pos = { x = 3, y = 0 },
    atlas = "jokers",
    cost = 100,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    order = 6,
    soul_pos = { x = 13, y = 0 },
    config = {},
    loc_txt = {
        ["en-us"] = {
            name = "Nami",
            text = {
                "{X:gold,C:white}tangerines.{}",
                "{C:inactive}(Gives {C:gold}$5{C:inactive} every {C:attention}3{C:inactive} seconds)"
            },
        },
    },
    add_to_deck = function(self, card, from_debuff)
        dollars_timer.start()
    end,
    update = function(self, card, dt)
        if libinsolence.count_num_of_joker("ins", "nami") >= 1 then
            dollars_timer.update(dt)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        dollars_timer.stop()
    end
})
