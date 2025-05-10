SMODS.Shader({
	key = "lesbian",
	path = "lesbian.fs",
})

SMODS.Edition({
	key = "lesbian_ed",
	shader = "lesbian",
	config = {
		extra = {
			x_mult = 2,
		},
	},
	loc_txt = {
		["en-us"] = {
			name = "Lesbian",
			label = "Lesbian",
			text = {
				"If card is a Queen and played with",
				"another Queen, give {X:red,C:white}X#1#{} Mult",
			},
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				self.config.extra.x_mult,
			},
		}
	end,
	calculate = function(self, card, context)
		local scored_queens_count = 0

		if context.cardarea == G.play and context.main_scoring then
			for _, v in
				pairs(
					--- @type CalcContext | (Card[] | table[])
					context.scoring_hand
				)
			do
				--- @type number
				local rank = v.base.id

				if rank == 12 then
					scored_queens_count = BEARO.UTILS.inc(scored_queens_count)
				end
			end

			if scored_queens_count >= 2 then
				return {
					Xmult_mod = self.config.extra.x_mult,
					message = "Heyyyy girll, whatcha doin'?",
					card = card,
				}
			else
				return {
					message = "i am lonely :(",
					card = card,
				}
			end
		end
	end,
})
