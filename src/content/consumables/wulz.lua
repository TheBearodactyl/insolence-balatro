SMODS.Consumable {
    key = "wulz",
    atlas = "consumables",
    pos = { x = 2, y = 0 },
    config = {},
    cost = 3,
    set = "Tarot",
    order = 14,
    loc_txt = {
        ["en-us"] = {
            name = "The Wulz",
            text = {
                "Adds the {C:attention}Woah{} enhancement",
                "to up to {C:green}2{} selected playing cards"
            }
        }
    },
    can_use = function(self, card)
        return (#G.hand.highlighted <= 2 and #G.hand.highlighted > 0)
    end,
    use = function(self, card, area, copier)
        local used_consumable = copier or card

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.4,
            func = function()
                play_sound("tarot1")
                used_consumable:juice_up(0.3, 0.5)
                return true
            end
        }))

        local percent = 1.15 - (1 - 0.999) / (1 - 0.998) * 0.3

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.15,
            func = function()
                if #G.hand.highlighted == 1 then
                    G.hand.highlighted[1]:flip()

                    play_sound("card1", percent)

                    G.hand.highlighted[1]:juice_up(0.3, 0.3)

                    return true
                else
                    G.hand.highlighted[1]:flip()
                    G.hand.highlighted[2]:flip()

                    play_sound("card1", percent)

                    G.hand.highlighted[1]:juice_up(0.3, 0.3)
                    G.hand.highlighted[2]:juice_up(0.3, 0.3)

                    return true
                end
            end
        }))

        delay(0.2)

        local percent = 0.85 + (1 - 0.999) / (1 - 0.998) * 0.3

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.15,
            func = function()
                if #G.hand.highlighted == 1 then
                    G.hand.highlighted[1]:set_ability(BEARO.woah, nil, false)
                    G.hand.highlighted[1]:flip()

                    play_sound("bearo_woah", percent)

                    G.hand.highlighted[1]:juice_up(0.3, 0.3)

                    return true
                else
                    G.hand.highlighted[1]:set_ability(BEARO.woah, nil, false)
                    G.hand.highlighted[2]:set_ability(BEARO.woah, nil, false)
                    G.hand.highlighted[1]:flip()
                    G.hand.highlighted[2]:flip()

                    play_sound("bearo_woah", percent)

                    G.hand.highlighted[1]:juice_up(0.3, 0.3)
                    G.hand.highlighted[2]:juice_up(0.3, 0.3)

                    return true
                end
            end
        }))

        delay(0.2)

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.4,
            func = function()
                play_sound("tarot2")
                used_consumable:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()

                return true
            end
        }))
    end
}
