SMODS.Blind({
	key = "chrisrock",
	atlas = "chrisrockatlas",
	pos = {
		x = 0,
		y = 0,
	},
	boss = {
		showdown = true,
	},
	boss_colour = G.C.RED,
	loc_txt = {
		["en-us"] = {
			name = "Chris Rock",
			text = {
				"Everything is debuffed",
				"unless you've beaten",
				"{C:attention}Will Smith",
			},
		},
	},
	debuff_hand = function(self, cards, hand, handname, check)
		for k, _ in pairs(G.GAME.defeated_blinds) do
			s = G.P_BLINDS[k]

			if s.name == "Will Smith" then
				return true
			else
				return false
			end
		end
	end,
})
