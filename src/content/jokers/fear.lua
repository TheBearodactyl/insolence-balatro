SMODS.Joker({
	key = "fear",
	pos = { x = 6, y = 0 },
	soul_pos = {
		x = 7,
		y = 0,
	},
	rarity = "defiant",
	blueprint_compat = true,
	cost = 50,
	order = 5,
	atlas = "jokers",
	loc_txt = {
		["en-us"] = {
			name = "{X:red,C:green}first{}{X:green,C:red}there{}{X:red,C:green}was{}{X:green,C:red}a{}{X:red,C:green}void.{}",
			text = {
				"{X:red,C:green}then...{} {X:green,C:red}there{}{X:red,C:green}was{}{X:green,C:red}headache.{}",
			},
		},
	},
	calculate = function(self, card, context)
		if G.jokers.cards and context.end_of_round and not context.repetition and not context.individual then
			local leftmost_joker = G.jokers.cards[1]

			if leftmost_joker.ability then
				local leftmost_data = leftmost_joker.ability
				local doubled_values = BEARO.UTILS.mod_vals(leftmost_data, 2)

				leftmost_joker.ability = doubled_values

				local curr_leftmost_xmult = leftmost_joker.ability.x_mult
				local curr_leftmost_mult = leftmost_joker.ability.mult
				local curr_leftmost_xchips = leftmost_joker.ability.x_chips

				leftmost_joker.ability.x_mult = curr_leftmost_xmult / 2
				leftmost_joker.ability.mult = curr_leftmost_mult / 2
				leftmost_joker.ability.x_chips = curr_leftmost_xchips / 2

				local msg_ver = pseudorandom("Migraine", 1, 10)

				if msg_ver < 5 then
					return {
						message = localize("k_migraine_ex"),
						card = leftmost_joker,
						message_card = leftmost_joker,
						card,
					}
				else
					return {
						message = localize("k_migraine2_ex"),
						card = leftmost_joker,
						message_card = leftmost_joker,
						card,
					}
				end
			end

			if not leftmost_joker.ability then
				return {
					message = "Nope!",
					card = card,
				}
			end
		end
	end,
})
