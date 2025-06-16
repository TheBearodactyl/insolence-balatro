local lcpref = Controller.L_cursor_press
function Controller:L_cursor_press(x, y)
    lcpref(self, x, y)
    if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
        SMODS.calculate_context({ ins_clicked_left = true })
    end
end

-- Released left mouse button
local lcrref = Controller.L_cursor_release
function Controller:L_cursor_release(x, y)
    lcrref(self, x, y)
    if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
        SMODS.calculate_context({ ins_released_left = true })
    end
end

SMODS.Joker({
    key = "wulzy",
    rarity = 2,
    cost = 4,
    pos = {
        x = 0,
        y = 0,
    },
    atlas = "enhancements",
    unlocked = true,
    discovered = true,
    order = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    loc_txt = {
        ["en-us"] = {
            name = "Wulzy",
            text = {
                "{C:attention}Woah{} cards give {C:chips}+50{} chips",
                "and {C:mult}+10{} mult for each owned",
                "{C:attention}Woah Joker{}",
                " ",
                "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips and {C:mult}+#2#{} Mult)"
            },
        },
    },
    loc_vars = function (self, info_queue, card)
        local woah_jokers_amt = libinsolence.count_num_of_joker("ins", "wulzy")

        return {
            vars = {
                50 * woah_jokers_amt,
                10 * woah_jokers_amt
            }
        }
    end,
    calculate = function(self, card, context)
        if context.ins_clicked_left and insolence.mod.config.woah_sfx == true then
            play_sound("ins_woah")
            card:juice_up(0.8, 0.5)
        end
    end,
})
