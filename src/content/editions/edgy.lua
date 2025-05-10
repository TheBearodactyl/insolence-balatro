SMODS.Shader({
	key = "edgy",
	path = "edgy.fs",
})

SMODS.Edition({
	key = "edgy_ed",
	shader = "edgy",
	config = {
		extra = 1.5,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				self.config.extra,
			},
		}
	end,
	loc_txt = {
		["en-us"] = {
			name = "Edgy",
			label = "Livin' on the Edge",
			text = {
				"Gives {X:red,C:white}X#1#{} mult on the last",
				"hand of the current round",
			},
		},
	},
	calculate = function(self, card, context)
		if
			context.cardarea == G.jokers
			and context.main_scoring
			and not context.repetition
			and G.GAME.current_round.hands_left == 0
			and mult
		then
			return {
				message = "edgy af",
				card = card,
				Xmult = self.config.extra,
			}
		end

		if
			context.cardarea == G.play
			and context.main_scoring
			and not context.repetition
			and G.GAME.current_round.hands_left == 0
			and mult
		then
			return {
				message = "edgy af",
				card = card,
				Xmult_mod = self.config.extra,
			}
		end
	end,
})
