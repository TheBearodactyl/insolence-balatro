SMODS.Shader({
	key = "bocchi",
	path = "bocchi.fs",
})

SMODS.Edition({
	key = "bocchi_ed",
	shader = "bocchi",
	config = {
		extra = {
			percent_chance = 10,
		},
	},
	loc_txt = {
		["en-us"] = {
			label = "ROCKIN'",
			text = {
				"Creates a {C:attention}Rock{} when played as a high card",
				"{C:inactive}{C:green}#1#%{}{C:inactive} chance to create a {C:attention}Stone Card{}",
				"{C:inactive}{C:green}#2#%{}{C:inactive} chance to create a {C:attention}Stone Joker{}",
			},
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				100 - self.config.extra.percent_chance,
				self.config.extra.percent_chance,
			},
		}
	end,
	in_shop = true,
	disable_base_shader = true,
	calculate = function(self, card, context)
		if context.cardarea == G.play and #context.scoring_hand == 1 and context.before then
			if insolib.chance(self.config.extra.percent_chance) == true then
				G.E_MANAGER:add_event(Event({
					func = function()
						local stone_joker = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_stone", nil)
						stone_joker:add_to_deck()
						stone_joker:start_materialize()
						G.jokers:emplace(stone_joker)

						return true
					end,
				}))

				return {
					message = "ROCK!",
					colour = G.C.SECONDARY_SET.Enhanced,
				}
			else
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.1,
					func = function()
						local front = pseudorandom_element(G.P_CARDS, pseudoseed("marb_fr"))
						G.playing_card = (G.playing_card and G.playing_card + 1) or 1
						local crd = Card(
							G.play.T.x + G.play.T.w / 2,
							G.play.T.y,
							G.CARD_W,
							G.CARD_H,
							front,
							G.P_CENTERS.m_stone,
							{ playing_card = G.playing_card }
						)
						crd:start_materialize({ G.C.SECONDARY_SET.Enhanced })
						G.deck:emplace(crd)
						table.insert(G.playing_cards, crd)

						return true
					end,
				}))

				card_eval_status_text(context.blueprint_card or self, "extra", nil, nil, nil, {
					message = localize("k_plus_stone"),
					colour = G.C.SECONDARY_SET.Enhanced,
				})

				G.E_MANAGER:add_event(Event({
					func = function()
						G.deck.config.card_limit = G.deck.config.card_limit + 1

						return true
					end,
				}))

				draw_card(G.play, G.deck, 90, "up", nil)
				playing_card_joker_effects({ true })

				return {
					message = "ROCK!",
					colour = G.C.SECONDARY_SET.Enhanced,
				}
			end
		end
	end,
})
