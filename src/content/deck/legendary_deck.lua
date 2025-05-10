SMODS.Back({
	key = "legendary_deck",
	atlas = "legendary",
	discovered = true,
	unlocked = true,
	pos = {
		x = 0,
		y = 0,
	},
	config = {
		extra = {
			extra_chips_bonus = 1,
		},
	},
	loc_txt = {
		["en-us"] = {
			name = "Legendary Deck",
			text = {
				"All cards have the {C:attention}Legendary{} enhancement",
				"Gain {C:gold}$#1#{} for every 1K chips at the",
				"end of round",
			},
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				self.config.extra.extra_chips_bonus,
			},
		}
	end,
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				for c = #G.playing_cards, 1, -1 do
					G.playing_cards[c]:set_ability("m_bearo_legendary_enh")
				end
				return true
			end,
		}))

		G.GAME.modifiers.money_per_thousand_chips = self.config.extra.extra_chips_bonus
	end,
})

local orig_er = G.FUNCS.evaluate_round
G.FUNCS.evaluate_round = function()
	orig_er()
	local pitchh = 0.95

	if G.GAME.chips > to_big(1000) and G.GAME.modifiers.money_per_thousand_chips then
		add_round_eval_row({
			dollars = G.GAME.chips / to_big(1000),
			disp = G.GAME.chips / to_big(1000),
			bonus = true,
			name = "chips",
			pitch = pitchh,
		})
	end
end
