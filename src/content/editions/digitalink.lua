SMODS.Shader {
    key = "digitalink",
    path = "digitalink.fs"
}

SMODS.Edition {
    key = "digitalink_ed",
    shader = "digitalink",
    loc_txt = {
        ["en-us"] = {
            name = "Digital Ink",
            label = "Grainy and Smeared",
            text = {
                "When scored, change suit at random.",
            }
        }
    },
    calculate = function(self, card, context)
        local suits = {
            "Hearts",
            "Diamonds",
            "Spades",
            "Clubs"
        }

        if context.cardarea == G.play and context.main_scoring and not context.repetition then
            G.E_MANAGER:add_event(Event {
                trigger = "after",
                delay = 0.4,
                func = function()
                    play_sound("tarot1")
                    card:juice_up(0.3, 0.5)

                    return true
                end
            })

            local percent = 1.15 - (1 - 0.999) / (1 - 0.998) * 0.3

            G.E_MANAGER:add_event(Event {
                trigger = "after",
                delay = 0.15,
                func = function()
                    card:flip()
                    play_sound("card1", percent)
                    card:juice_up(0.3, 0.3)

                    return true
                end
            })

            delay(0.2)

            local percent = 0.85 + (1 - 0.999) / (1 - 0.998) * 0.3

            G.E_MANAGER:add_event(Event {
                trigger = "after",
                delay = 0.15,
                func = function()
                    card:flip()
                    card:change_suit(BEARO.UTILS.choose_rand(suits))

                    play_sound("card1", percent)

                    card:juice_up(0.3, 0.3)

                    return true
                end
            })

            delay(0.2)
        end
    end
}