SMODS.Shader({
	key = "synth",
	path = "synth.fs",
})

SMODS.Edition({
	key = "synth_ed",
	shader = "synth",
	loc_txt = {
		["en-us"] = {
			name = "Synth",
			label = "Synthesized",
			text = {
				"Gives {X:red,C:white}X#1#{} Mult when",
				"played with an {C:attention}Equalize{} card",
				"or when you own an {C:attention}Equalize{} Joker",
			},
		},
	},
	config = {
		extra = {
			xmult = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["e_bearo_equalize_ed"]

		return {
			vars = {
				self.config.extra.xmult,
			},
		}
	end,
	calculate = function(self, card, context)
		local equalize_count = 0

		if context.scoring_hand then
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i].edition and context.scoring_hand[i].edition.key == "e_bearo_equalize_ed" then
					equalize_count = equalize_count + 1
				end
			end
		end

		for _, v in pairs(G.jokers.cards) do
			local ed = v.edition and v.edition or {}

			if ed.key and ed.key == "e_bearo_equalize_ed" then
				equalize_count = equalize_count + 1
			end
		end

		if
			(context.main_scoring and context.cardarea == G.play and equalize_count >= 1)
			or (context.joker_main and context.cardarea == G.jokers and equalize_count >= 1)
		then
			return {
				Xmult_mod = self.config.extra.xmult,
				card = card,
				message = "Synthesized!",
			}
		end
	end,
})
