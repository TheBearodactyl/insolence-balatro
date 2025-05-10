SMODS.Joker({
	key = "metroman",
	atlas = "metroman",
	pos = { x = 0, y = 0 },
	rarity = "insolent",
	blueprint_compat = true,
	cost = 100,
	loc_txt = {
		["en-us"] = {
			name = "{X:gold,C:white}M{X:white,C:gold}e{X:gold,C:white}t{X:white,C:gold}r{X:gold,C:white}o{X:white,C:gold}m{X:gold,C:white}a{X:white,C:gold}n{}",
			text = {
				"{X:gold,C:white}speed.{}",
				"{C:inactive}(Retrigger the leftmost Joker {C:attention}#1# times{}{C:inactive} per {C:attention}Lucky{}{C:inactive} card in your deck){}",
			},
		},
	},
	config = {
		extra = {
			retriggers = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky

		return {
			vars = {
				self.config.extra.retriggers,
			},
		}
	end,
	calculate = function(self, card, context)
		local lucky_card_tally = 0

		for k, v in pairs(G.deck.cards) do
			--- @type Card
			local crd = v

			if crd.config.center == G.P_CENTERS.m_lucky then
				lucky_card_tally = lucky_card_tally + 1
			end
		end

		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
			if context.other_card == G.jokers.cards[1] then
				return {
					message = localize("k_again_ex"),
					repetitions = lucky_card_tally * self.config.extra.retriggers,
					card = card,
				}
			end
		end
	end,
})
