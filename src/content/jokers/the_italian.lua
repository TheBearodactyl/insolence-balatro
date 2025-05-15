SMODS.Shader({
	key = "theitalian",
	path = "theitalian.fs",
})

SMODS.Joker({
	key = "the_italian",
	atlas = "jokers",
	pos = { x = 3, y = 1 },
	rarity = "insolent",
	loc_txt = {
		["en-us"] = {
			name = "The Italian",
			text = {
				"Creates a {C:attention}Pizza{} at the end of shop",
				" ",
				"Shader: https://www.shadertoy.com/view/4ssSWs",
			},
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["m_bearo_unoriginal_art"]
		info_queue[#info_queue + 1] = G.P_CENTERS["j_bearo_thepizza"]
	end,
	draw = function(self, card, layer)
		if card.config.center.discovered or card.bypass_discovery_center then
			card.children.center:draw_shader("bearo_theitalian", nil, card.ARGS.send_to_shader)
		end
	end,
	calculate = function(self, card, context)
		if context.ending_shop and not (context.individual or context.repetition and not context.blueprint) then
			local pizza = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_bearo_thepizza")
			pizza:add_to_deck()

			G.jokers:emplace(pizza)

			return {
				message = "It's Pizza Time",
				card = card,
			}
		end
	end,
})
