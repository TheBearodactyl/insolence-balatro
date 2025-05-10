if JokerDisplay then
	-- Boobs Joker
	JokerDisplay.Definitions["j_bearo_boobs"] = {
		text = {
			{ text = "+", colour = G.C.CHIPS },
			{ ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
		},
	}

	-- Entropy
	JokerDisplay.Definitions["j_bearo_entropy"] = {
		text = {
			{ text = "^" },
			{ ref_table = "card.ability.extra", ref_value = "x_mult" },
		},
	}

	-- Fingertips
	JokerDisplay.Definitions["j_bearo_fingertips"] = {
		text = {
			{ text = "[+" },
			{ ref_table = "card.ability", ref_value = "extra" },
			{ text = "]" },
		},
	}

	-- Stopped Heart
	JokerDisplay.Definitions["j_bearo_heart_stop"] = {
		text = {
			{ text = "X", colour = G.C.RED },
			{ ref_table = "card.ability.extra", ref_value = "x_mult" },
		},
		reminder_text = {
			{ text = "(" },
			{ ref_table = "G.GAME.probabilities", ref_value = "normal" },
			{ text = " in " },
			{ ref_table = "card.ability.extra", ref_value = "reset_chance" },
			{ text = ")" },
		},
	}

	-- GMOD
	JokerDisplay.Definitions["j_bearo_garry"] = {
		reminder_text = {
			{ ref_table = "card.ability.extra", ref_value = "rounds_left", colour = G.C.GREEN },
			{ text = " rounds left" },
		},
	}

	-- Luffy
	JokerDisplay.Definitions["j_bearo_mugiwara"] = {
		text = {
			{ text = "Gear " },
			{ ref_table = "card.ability.extra", ref_value = "gear" },
		},
	}
end
