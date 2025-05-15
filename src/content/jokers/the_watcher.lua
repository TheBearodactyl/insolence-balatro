SMODS.Rarity({
	key = "watchin",
	badge_colour = HEX(BEARO.UTILS.word_to_color("watching")),
	loc_txt = {
		["en-us"] = {
			name = "Watching",
			label = "Watching",
		},
	},
})

SMODS.Shader({
	key = "eyes",
	path = "eyes.fs",
})

SMODS.Joker({
	name = "Watching",
	key = "the_watcher",
	atlas = "jokers",
	rarity = "bearo_watchin",
	pos = {
		x = 3,
		y = 1,
	},
	loc_txt = {
		["en-us"] = {
			name = "Watching",
			text = {
				"Watching",
			},
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["m_bearo_unoriginal_art"]
	end,
	draw = function(self, card, layer)
		if card.config.center.discovered or card.bypass_discovery_center then
			card.children.center:draw_shader("bearo_eyes", nil, card.ARGS.send_to_shader)
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		function Blind:stay_flipped(area, card)
			if area == G.hand then
				return false
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		function Blind:stay_flipped(area, card)
			if not self.disabled then
				if area == G.hand then
					if
						self.name == "The Wheel"
						and pseudorandom(pseudoseed("wheel")) < G.GAME.probabilities.normal / 7
					then
						return true
					end
					if
						self.name == "The House"
						and G.GAME.current_round.hands_played == 0
						and G.GAME.current_round.discards_used == 0
					then
						return true
					end
					if self.name == "The Mark" and card:is_face(true) then
						return true
					end
					if self.name == "The Fish" and self.prepped then
						return true
					end
				end
			end
		end
	end,
})
