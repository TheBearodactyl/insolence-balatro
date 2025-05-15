SMODS.Enhancement({
	key = "unoriginal_art",
	atlas = "jokers",
	in_pool = function(self, args)
		return false
	end,
	pos = { x = 3, y = 1 },
	loc_txt = {
		["en-us"] = {
			name = "Unoriginal Shader Code",
			text = {
				"This card uses unoriginal shader code",
				"and I take {X:red,C:white}NO{} credit whatsoever for the",
				"creation of this shader in any way,",
				"shape, or form. A link to the original",
				"shader will be available in the description",
				"for this card",
			},
		},
	},
})
