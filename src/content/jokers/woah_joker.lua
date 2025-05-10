SMODS.Joker({
	key = "wulzy",
	rarity = 1,
	pos = {
		x = 0,
		y = 0,
	},
	atlas = "enhancements",
	cost = 1,
	unlocked = true,
	discovered = true,
	order = 1,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	loc_txt = {
		["en-us"] = {
			name = "Wulzy",
			text = {
				"Plays the {C:red}W{}{C:gold}o{}{C:red}a{}{C:gold}h{} SFX",
				"evey time you {C:blue}Click{}",
				" ",
				"{C:inactive}(Causes Woah cards to give 50 chips and 5 mult){}",
			},
		},
	},
	calculate = function(self, card, context)
		if context.bearo_clicked_left and BEARO.MOD.config.woah_sfx == true then
			play_sound("bearo_woah")
			card:juice_up(0.8, 0.5)
		end
	end,
})
