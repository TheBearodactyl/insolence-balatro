BEARO.too_many_galaxies = false

SMODS.Shader({
	key = "universe",
	path = "universe.fs",
})

--- @param card Card
--- @return boolean
local function has_galaxy(card)
	if card and card.edition then
		if card.edition.key == "e_bearo_universe_ed" then
			return true
		end
	end

	return false
end

SMODS.Edition({
	key = "universe_ed",
	shader = "universe",
	config = {
		extra = {
			ante_mod = -1,
		},
	},
	galaxy_card = true,
	loc_txt = {
		["en-us"] = {
			name = "A Galaxy",
			label = "Multiversal",
			text = {
				"Play as a single card to reduce the",
				"ante by {C:red}#1#{}. {C:red}Self destructs{}",
				" ",
				"Only {C:green}1{} may exist at a time.",
				"{C:inactive,s:0.6}(A small fragment of the universe...){}",
			},
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				self.config.extra.ante_mod,
			},
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		local galaxy_count = 0

		if G.deck and G.deck.cards then
			for _, v in pairs(G.deck.cards) do
				if has_galaxy(v) then
					galaxy_count = BEARO.UTILS.inc(galaxy_count)
				end
			end
		end

		BEARO.too_many_galaxies = galaxy_count > 1

		if BEARO.too_many_galaxies then
			card:shatter()
			card.shattered = true
		end
	end,
	on_apply = function(card)
		local galaxy_count = 0

		if G.deck and G.deck.cards then
			for _, v in pairs(G.deck.cards) do
				if has_galaxy(v) then
					galaxy_count = BEARO.UTILS.inc(galaxy_count)
				end
			end
		end

		BEARO.too_many_galaxies = galaxy_count > 1

		if BEARO.too_many_galaxies then
			card:shatter()
			card.shattered = true
		end
	end,
	calculate = function(self, card, context)
		local galaxy_count = 0

		if G.deck and G.deck.cards then
			for _, v in pairs(G.deck.cards) do
				if has_galaxy(v) then
					galaxy_count = BEARO.UTILS.inc(galaxy_count)
				end
			end
		end

		BEARO.too_many_galaxies = galaxy_count > 1

		if BEARO.too_many_galaxies then
			card:shatter()
			card.shattered = true
		end

		if
			context.before
			and G.GAME.current_round.hands_played == 0
			and not card.shattered
			and not context.repetition
			and context.cardarea == G.play
		then
			if #context.scoring_hand == 1 then
				ease_ante(self.config.extra.ante_mod)
				context.scoring_hand[1]:shatter()
				context.scoring_hand[1].shattered = true
			end

			return {
				message = "The Stars are Shimmering",
			}
		end
	end,
})
