SMODS.Shader({
	key = "tiled",
	path = "tiled.fs",
})

SMODS.Edition({
	key = "tiled_ed",
	shader = "tiled",
	loc_txt = {
		["en-us"] = {
			name = "Tiled",
			label = "Tiled",
			text = {
				"All {C:attention}Tiled{} cards are",
				"drawn together.",
				" ",
				"{C:inactive}haha get it 'drawn together'{}",
				"{C:inactive}yknow like that one cartoon 'drawn together'{}",
				"{C:inactive,s:4}GET IT?????{}",
				"{C:inactive,s:0.75}kill me{}"
			},
		},
	},
})

local orig_dfdth = G.FUNCS.draw_from_deck_to_hand
G.FUNCS.draw_from_deck_to_hand = function(e)
	orig_dfdth(e)

	G.E_MANAGER:add_event(Event({
		delay = 0.0,
		trigger = "before",
		func = function()
			local drawn_tiled = {}
			local tiled_cards = {}

			for i = 1, #G.hand.cards do
				--- @type Card
				local card = G.hand.cards[i]

				if card.edition and card.edition.key == "e_bearo_tiled_ed" then
					table.insert(drawn_tiled, card)
				end
			end

			if #drawn_tiled > 0 then
				for i = 1, #G.deck.cards do
					--- @type Card
					local card = G.deck.cards[i]

					if card.edition and card.edition.key == "e_bearo_tiled_ed" then
						table.insert(tiled_cards, card)
					end
				end

				for i = 1, #tiled_cards do
					draw_card(G.deck, G.hand, i * 100 / #tiled_cards, "up", true, tiled_cards[i])
				end
			end

			return true
		end,
	}))
end
