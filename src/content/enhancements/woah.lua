SMODS.Sound {
    key = "woah",
    path = "woah.ogg",
}

BEARO.woah = SMODS.Enhancement {
    key = "woah_enh",
    atlas = "enhancements",
    config = {
        extra = {
            e_chips_low = 10,
            e_chips_high = 50,
            e_mult_low = 1,
            e_mult_high = 5,
            odds = 3
        }
    },
    loc_txt = {
        ["en-us"] = {
            name = "WOAAAAHH",
            text = {
                "it's Wulzy.",
                "{C:inactive}gives between {C:green}10{} {C:inactive}and{} {C:green}50{} {C:inactive}extra chips{}"
            }
        }
    },
    pos = { x = 0, y = 0 },
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            local extra_chips = pseudorandom(
                "Extra Chips Amount",
                self.config.extra.e_chips_low,
                self.config.extra.e_chips_high
            )

            local extra_mult = pseudorandom(
                "Extra Mult Amount",
                self.config.extra.e_mult_low,
                self.config.extra.e_mult_high
            )

            G.E_MANAGER:add_event(Event {
                trigger = "after",
                delay = 0.2,
                func = function()
                    play_sound("bearo_woah")
                    card:juice_up(0.8, 0.5)
                    return true
                end
            })

            return {
                chips = extra_chips,
                mult = extra_mult
            }
        end
    end,
}
