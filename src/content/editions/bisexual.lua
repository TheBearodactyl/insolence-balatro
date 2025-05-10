SMODS.Shader({
	key = "bisexual",
	path = "bisexual.fs",
})

SMODS.Edition({
	key = "bisexual_ed",
	shader = "bisexual",
	config = {
		extra = {
			x_mult = 2,
		},
	},
	loc_txt = {
		["en-us"] = {
			name = "Bisexual",
			label = "Bisexual",
			text = {
				"Gives {X:red,C:white}X#1#{} {C:red}Mult{} if played",
				"with a {C:attention}King{} and a {C:attention}Queen{}",
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
		if context.cardarea == G.play and context.main_scoring then
			local has_king = false
			local has_queen = false

			for _, v in
				pairs(
					--- @type CalcContext | (Card[] | table[])
					context.scoring_hand
				)
			do
				local rank = v.base.id

				if rank == 12 then
					has_queen = true
				elseif rank == 13 then
					has_king = true
				end
			end

			if has_king == true and has_queen == true then
				return {
					Xmult_mod = self.config.extra.x_mult,
					message = "IT'S RAININ' MEN (and women)",
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
