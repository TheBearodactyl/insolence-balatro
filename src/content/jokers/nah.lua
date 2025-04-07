SMODS.Joker {
    key = "lolnah",
    pos = { x = 8, y = 0 },
    rarity = "bad",
    blueprint_compat = true,
    cost = 8,
    order = 10,
    atlas = "jokers",
    add_to_deck = function (self, card, from_debuff)
        card.ability.eternal = true
        ease_ante(1e309)
        end_round()
    end,
    remove_from_deck = function (self, card, from_debuff)
        ease_ante(-1e309)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = -8
            }
        end
    end
}