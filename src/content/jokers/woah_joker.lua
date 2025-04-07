local lcpref = Controller.L_cursor_press
--- @diagnostic disable-next-line: duplicate-set-field
function Controller:L_cursor_press(x, y)
    lcpref(self, x, y)
    if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
        SMODS.calculate_context({ bearo_clicked = true })
    end
end

SMODS.Joker {
    key = "wulzy",
    rarity = 1,
    pos = {
        x = 0,
        y = 0
    },
    atlas = "enhancements",
    cost = 500,
    unlocked = true,
    discovered = true,
    order = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.bearo_clicked then
            G.E_MANAGER:add_event(Event {
                trigger = "after",
                delay = 0.8,
                func = function()
                    play_sound("bearo_woah")
                    card:juice_up(0.8, 0.5)
                    return true
                end
            })
        end
    end
}
