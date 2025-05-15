SMODS.Shader({
	key = "lightshow",
	path = "lightshow.fs",
})

SMODS.Edition({
	key = "lightshow_ed",
	shader = "lightshow",
	loc_txt = {
		["en-us"] = {
			name = "Lightshow",
			label = "so prettyyyy :D",
			text = {
				"Cards with this edition always",
				"have the {C:attention}Rank{} and {C:attention}Suit{}",
				"currently used by the {C:attention}Idol{}"
			},
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_idol
	end,
	calculate = function(self, card, context)
	end
})
