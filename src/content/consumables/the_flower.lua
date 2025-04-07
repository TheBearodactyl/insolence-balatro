SMODS.Consumable {
    key = "flower",
    atlas = "consumables",
    pos = { x = 3, y = 0 },
    soul_pos = { x = 4, y = 0 },
    hidden = true,
    set = "Spectral",
    config = {},
    cost = 20,
    order = 10000000,
    can_use = function(self, card)
        return #G.jokers.cards < G.jokers.config.card_limit
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event {
            trigger = "after",
            delay = 0.4,
            func = function()
                play_sound("timpani")
                local insolence = create_card("Joker", G.jokers, nil, "insolent", nil, nil, nil, nil)
                insolence:add_to_deck()
                G.jokers:emplace(insolence)
                card:juice_up(0.3, 0.5)
                return true
            end
        })
        delay(0.6)
    end
}
