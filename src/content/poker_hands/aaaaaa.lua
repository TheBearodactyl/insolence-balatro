SMODS.PokerHandPart({
	key = "6",
	func = function(hand)
		return get_X_same(6, hand)
	end,
})

SMODS.PokerHand({
	key = "aaaaaa",
	mult = 24,
	chips = 200,
	l_mult = 5,
	l_chips = 20,
	atlas = "jokers",
	above_hand = "Flush Five",
	visible = true,
	pos = BEARO.UTILS.placeholder_sprite(),
	example = {
		{ "H_A", true },
		{ "D_A", true },
		{ "D_A", true },
		{ "C_A", true },
		{ "S_A", true },
		{ "H_A", true },
	},
	loc_txt = {
		["en-us"] = {
			name = "AAAAAA",
			description = {
				"Six Aces of any Suit",
			},
		},
	},
	--- @param parts table<SMODS.PokerHandPart>
	--- @param hand table<Card>
	evaluate = function(parts, hand)
		local aces = 0

		for i = 1, #hand do
			if hand[i]:get_id() == 14 then
				aces = aces + 1
			end
		end

		if next(parts.bearo_6) and aces == 6 then
			return {
				SMODS.merge_lists(parts.bearo_6),
			}
		end

		return {}
	end,
})

SMODS.PokerHand({
	key = "flush_aaaaaa",
	mult = 30,
	chips = 300,
	l_mult = 6,
	l_chips = 24,
	atlas = "jokers",
	above_hand = "AAAAAA",
	visible = true,
	pos = BEARO.UTILS.placeholder_sprite(),
	example = {
		{ "D_A", true },
		{ "D_A", true },
		{ "D_A", true },
		{ "D_A", true },
		{ "D_A", true },
		{ "D_A", true },
	},
	loc_txt = {
		["en-us"] = {
			name = "Flush AAAAAA",
			description = {
				"Six Aces of one Suit",
			},
		},
	},
	--- @param parts table<SMODS.PokerHandPart>
	--- @param hand table<Card>
	evaluate = function(parts, hand)
		local aces = 0

		for i = 1, #hand do
			if hand[i]:get_id() == 14 then
				aces = aces + 1
			end
		end

		if next(parts.bearo_6) and next(parts._flush) and aces == 6 then
			return {
				SMODS.merge_lists(parts.bearo_6),
			}
		end

		return {}
	end,
})
