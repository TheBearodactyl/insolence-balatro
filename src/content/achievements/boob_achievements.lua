SMODS.Achievement({
	key = "grow_boobs",
	atlas = "jokers",
	pos = BEARO.UTILS.boobs_sprite(BEARO.MOD),
	order = 6,
	loc_txt = {
		["en-us"] = {
			name = "Grow Boobs",
			description = "Obtain at least 2 boobs",
		},
	},
	unlock_condition = function(self, args)
		if args.type == "modify_jokers" then
			if G.jokers then
				local boobs_count = BEARO.UTILS.count_boobs()

				if boobs_count >= 2 then
					return true
				end
			end
		end
	end,
})
