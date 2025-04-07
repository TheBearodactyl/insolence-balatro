SMODS.Joker {
    key = "eternalinator",
    atlas = "jokers",
    pos = BEARO.UTILS.placeholder_sprite(),
    cost = 7,
    rarity = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.modifiers.enable_eternals_in_shop = true
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.modifiers.enable_eternals_in_shop = false
    end
}
