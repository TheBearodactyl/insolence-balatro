SMODS.Shader({
	key = "digitalink",
	path = "digitalink.fs",
})

SMODS.Edition({
	key = "printerink_ed",
	shader = "digitalink",
	loc_txt = {
		["en-us"] = {
			name = "Printer Ink",
			label = "Grainy and Smeared",
			text = { "A better Wild Card" },
		},
	},
})

-- -- Bugged???
function Card:is_suit(suit, bypass_debuff, flush_calc)
	if flush_calc then
		if self.ability.effect == "Stone Card" then
			return false
		end

		if self.ability.name == "Wild Card" and not self.debuff then
			return true
		end

		if self.edition and self.edition.key == "e_bearo_printerink_ed" then
			return true
		end

		if
			next(find_joker("Smeared Joker"))
			and (self.base.suit == "Hearts" or self.base.suit == "Diamonds")
				== (suit == "Hearts" or suit == "Diamonds")
		then
			return true
		end

		return self.base.suit == suit
	else
		if self.debuff and not bypass_debuff then
			return
		end

		if self.ability.effect == "Stone Card" then
			return false
		end

		if self.ability.name == "Wild Card" then
			return true
		end

		if self.edition and self.edition.key == "e_bearo_printerink_ed" then
			return true
		end

		if
			next(find_joker("Smeared Joker"))
			and (self.base.suit == "Hearts" or self.base.suit == "Diamonds")
				== (suit == "Hearts" or suit == "Diamonds")
		then
			return true
		end
		return self.base.suit == suit
	end
end
