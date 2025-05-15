SMODS.Blind({
	key = "willsmith",
	atlas = "willsmithatlas",
	pos = {
		x = 0,
		y = 0,
	},
	boss = {
		showdown = true,
	},
	mult = 20,
	boss_colour = G.C.RED,
	loc_txt = {
		["en-us"] = {
			name = "Will Smith",
			text = {
				"Extremely Large Blind",
				" ",
				"Disables the Chris Rock boss blind",
			},
		},
	},
	defeat = function(self)
		BEARO.defeated_will_smith = true
	end,
})
