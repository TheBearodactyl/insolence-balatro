SMODS.Joker({
	key = "probablynot",
	atlas = "jokers",
	pos = { x = 9, y = 0 },
	soul_pos = {
		x = 12,
		y = 2,
	},
	cost = 5,
	rarity = 2,
	config = {
		extra = {
			probability_mod = 2,
		},
	},
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	loc_txt = {
		["en-us"] = {
			name = "Probably Not...",
			text = {
				"Reverse Oops",
				"{C:inactive}(Divides all listed probabilities by #1#){}",
			},
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				self.config.extra.probability_mod,
			},
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		for k, v in pairs(G.GAME.probabilities) do
			G.GAME.probabilities[k] = v / self.config.extra.probability_mod
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		for k, v in pairs(G.GAME.probabilities) do
			G.GAME.probabilities[k] = v * self.config.extra.probability_mod
		end
	end,
})
