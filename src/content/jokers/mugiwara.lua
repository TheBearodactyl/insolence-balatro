-- Music code taken from Neato Jokers

local music_countdown = G.TIMERS.UPTIME
SMODS.Sound({
	key = "overthetop_music",
	path = "Over the Top.mp3",
	volume = 5,
	pitch = 1,
	select_music_track = function(self)
		if BEARO.MOD.config.mugiwara_music == 1 then
			-- Always Enabled
			return 100
		elseif BEARO.MOD.config.mugiwara_music == 2 and #SMODS.find_card("j_bearo_mugiwara") > 0 then
			-- Enable when Mugiwara present
			return 100
		elseif BEARO.MOD.config.mugiwara_music == 3 and music_countdown > G.TIMERS.UPTIME then
			return 100
		else
		end
	end,
})

SMODS.Joker({
	key = "mugiwara",
	rarity = "strawhat",
	pos = { x = 3, y = 0 },
	atlas = "jokers",
	cost = 100,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	order = 5,
	gear1 = nil,
	gear2 = nil,
	gear3 = nil,
	gear4 = nil,
	gear5 = nil,
	eternal_compat = false,
	perishable_compat = false,
	soul_pos = { x = 11, y = 0 },
	config = {
		extra = {
			gear = 1,
		},
	},
	loc_txt = {
		["en-us"] = {
			name = "{X:gold,C:red}Mugiwara{}",
			text = {
				"{X:gold,C:red}laughter.{}",
			},
		},
	},
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			music_countdown = G.TIMERS.UPTIME + 10.3

			local juice_while = function()
				return BEARO.MOD.config.mugiwara_music == 3
					and G.SETTINGS.SOUND.volume > 0
					and G.SETTINGS.SOUND.music_volume > 0
					and music_countdown > G.TIMERS.UPTIME
			end

			if juice_while() then
				juice_card_until(card, juice_while)
			end
		end
	end,
	update = function(self, card, dt)
		if BEARO.UTILS.count_num_of_joker_bearo("mugiwara") <= 4 then
			card.ability.extra.gear = 2

			self.gear1 = true
			self.gear2 = false
			self.gear3 = false
			self.gear4 = false
			self.gear5 = false
		elseif
			BEARO.UTILS.count_num_of_joker_bearo("mugiwara") >= 5
			and BEARO.UTILS.count_num_of_joker_bearo("mugiwara") <= 8
		then
			card.ability.extra.gear = 3

			self.gear1 = true
			self.gear2 = true
			self.gear3 = true
			self.gear4 = false
			self.gear5 = false
		elseif BEARO.UTILS.count_num_of_joker_bearo("mugiwara") == 9 then
			card.ability.extra.gear = 4

			self.gear1 = true
			self.gear2 = true
			self.gear3 = true
			self.gear4 = true
			self.gear5 = false
		elseif BEARO.UTILS.count_num_of_joker_bearo("mugiwara") >= 10 then
			card.ability.extra.gear = 5

			self.gear1 = true
			self.gear2 = true
			self.gear3 = true
			self.gear4 = true
			self.gear5 = true
		end
	end,
	calculate = function(self, card, context)
		-- if (SMODS.Mods["Cryptid"] or {}).can_load then
		if context.end_of_round and not context.repetition and not context.individual then
			for jkr = 1, #G.jokers.cards do
				local check = false

				-- if not Card.no(G.jokers.cards[jkr], "immutable", true) then
				Cryptid.with_deck_effects(G.jokers.cards[jkr], function(crd)
					Cryptid.misprintize(crd, { min = self.config.extra.gear, max = self.config.extra.gear }, nil, true)
				end)
				-- end
				check = true
				if check then
					card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil, {
						message = localize("k_upgrade_ex"),
						colour = G.C.GREEN,
					})
				end

				return nil, true
			end
		end
		-- end
	end,
})
