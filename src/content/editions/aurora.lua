SMODS.Shader({
	key = "aurora",
	path = "aurora.fs",
})

SMODS.Edition({
	key = "aurora_ed",
	shader = "aurora",
	config = {
		extra = {
			ee_mult = 1.1,
			trigger = nil, -- thanks cryptid
		},
	},
	loc_txt = {
		["en-us"] = {
			name = "Aurora",
			label = "Aurora Borealis",
			text = {
				"Gives {X:planet,C:white,s:5,E:1}^^#1#{} mult.",
			},
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				self.config.extra.ee_mult,
			},
		}
	end,
	calculate = function(self, card, context)
		if
			(context.edition and context.cardarea == G.jokers and self.config.extra.trigger)
			or (context.main_scoring and context.cardarea == G.play)
		then
			return {
				ee_mult = self.config.extra.ee_mult,
				card = card,
				message = "Starry...",
			}
		end

		if context.joker_main then
			self.config.extra.trigger = true
		end

		if context.after then
			self.config.extra.trigger = nil
		end
	end,
})
