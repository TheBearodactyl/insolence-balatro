SMODS.Joker({
	key = "eternalinator",
	atlas = "jokers",
	pos = {
		x = 16,
		y = 0,
	},
	cost = 7,
	rarity = 2,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	loc_txt = {
		["en-us"] = {
			name = "Eternalinator",
			text = {
				"Allows {C:yellow}Eternal{} Jokers",
				"to appear in the Shop",
			},
		},
	},
	add_to_deck = function(self, card, from_debuff)
		G.GAME.modifiers.enable_eternals_in_shop = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.modifiers.enable_eternals_in_shop = false
	end,
})
