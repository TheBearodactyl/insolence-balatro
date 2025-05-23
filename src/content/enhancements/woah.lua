SMODS.Sound({
	key = "woah",
	path = "woah.ogg",
})

BEARO.woah = SMODS.Enhancement({
	key = "woah_enh",
	atlas = "enhancements",
	config = {
		extra = {
			e_chips_low = 10,
			e_chips_high = 50,
			e_mult_low = 1,
			e_mult_high = 5,
		},
	},
	loc_txt = {
		["en-us"] = {
			name = "WOAAAAHH",
			text = {
				"it's Wulzy.",
				"{C:inactive}(Gives between #1#-50 {}{C:chips}chips{}{C:inactive} and #2#-5 {}{C:mult}mult{}{C:inactive}){}",
			},
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				self.config.extra.e_chips_low,
				self.config.extra.e_mult_low,
			},
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.main_scoring then
			local extra_chips =
				pseudorandom("Extra Chips Amount", self.config.extra.e_chips_low, self.config.extra.e_chips_high)

			local extra_mult =
				pseudorandom("Extra Mult Amount", self.config.extra.e_mult_low, self.config.extra.e_mult_high)

			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					if BEARO.MOD.config.woah_sfx == true then
						play_sound("bearo_woah")
					end
					card:juice_up(0.8, 0.5)
					return true
				end,
			}))

			return {
				chips = extra_chips,
				mult = extra_mult,
			}
		end
	end,
	update = function(self, card, dt)
		if BEARO.UTILS.count_num_of_joker_bearo("wulzy") >= 1 then
			self.config.extra.e_chips_low = 50
			self.config.extra.e_mult_low = 5
		else
			self.config.extra.e_chips_low = 10
			self.config.extra.e_mult_low = 1
		end
	end,
})
