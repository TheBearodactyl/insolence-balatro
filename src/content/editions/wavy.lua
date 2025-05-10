SMODS.Shader({
	key = "wavy",
	path = "wavy.fs",
})

SMODS.Edition({
	key = "wavy_ed",
	shader = "wavy",
	config = {
		extra = {
			mult = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				self.config.extra.mult,
			},
		}
	end,
	loc_txt = {
		["en-us"] = {
			name = "Wavy",
			label = "Tsunami time",
			text = {
				"Gives {C:red}+#1#{} Mult",
			},
		},
	},
	calculate = function(self, card, context)
		if context.setting_blind then
			local new_mult = BEARO.UTILS.wave_number(self.config.extra.mult)
			self.config.extra.mult = new_mult
		end
	end,
})
