SMODS.Shader({
	key = "equalize",
	path = "equalize.fs",
})

SMODS.Edition({
	key = "equalize_ed",
	shader = "equalize",
	loc_txt = {
		["en-us"] = {
			name = "Equalize",
			label = "Equalized",
			text = {
				"Gives {X:chips,C:white}X#1#{} Chips when",
				"played with a {C:attention}Synth{} card",
				"or when you own a {C:attention}Synth{} Joker",
			},
		},
	},
	config = {
		extra = {
			xchips = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		-- info_queue[#info_queue + 1] = G.P_CENTERS["e_bearo_synth_ed"]

		return {
			vars = {
				self.config.extra.xchips,
			},
		}
	end,
	calculate = function(self, card, context)
		local synth_count = 0

		if context.scoring_hand then
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i].edition and context.scoring_hand[i].edition.key == "e_bearo_synth_ed" then
					synth_count = synth_count + 1
				end
			end
		end

		for _, v in pairs(G.jokers.cards) do
			local ed = v.edition and v.edition or {}

			if ed.key and ed.key == "e_bearo_synth_ed" then
				synth_count = synth_count + 1
			end
		end

		if
			(context.main_scoring and context.cardarea == G.play and synth_count >= 1)
			or (context.joker_main and context.cardarea == G.jokers and synth_count >= 1)
		then
			return {
				Xchip_mod = self.config.extra.xchips,
				card = card,
				message = "Equalized!",
			}
		end
	end,
})
