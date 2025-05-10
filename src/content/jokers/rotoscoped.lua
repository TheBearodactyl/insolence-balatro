--- @type table<table<string, table>>
local roto_msgs = {
	{ string = "*takes a puff*", colour = G.C.BLACK },
	{ string = "WOAH, what the fuck dude...", colour = G.C.BLACK },
	{ string = "don't TOUCH ME...", colour = G.C.BLACK },
	{ string = "Dude, what the fuck...", colour = G.C.BLACK },
	{ string = "Why're you fucking HERE man", colour = G.C.BLACK },
	{ string = "you're so OLD. Where's your WIFE", colour = G.C.BLACK },
	{ string = "Go home to your family dude...", colour = G.C.BLACK },
}

SMODS.Joker({
	key = "roto",
	atlas = "rotoscoped",
	pos = { x = 0, y = 0 },
	rarity = "insolent",
	blueprint_compat = true,
	cost = 50,
	-- pixel_size = {
	--     w = 57 / 69 * 71,
	--     h = 57 / 69 * 71,
	--     w = 58,
	--     h = 58,
	-- },
	config = {},
	loc_txt = {
		["en-us"] = {
			name = "Rotoscoped",
			text = {
				"{C:inactive}Triggers any joker effects that happen{}",
				"{C:inactive}when adding the leftmost joker to the deck{}",
				"{C:inactive}at the end of round. The results of all{}",
				"{C:inactive}retriggers will persist throughout the run.{}",
			},
		},
	},
	loc_vars = function(self, info_queue, card)
		card.ability.blueprint_compat_ui = card.ability.blueprint_compat_ui or ""
		card.ability.blueprint_compat_check = nil

		return {
			main_start = { BEARO.UTILS.cycling_text(roto_msgs, false, 0.75, 0.5) },
			main_end = (card.area and card.area == G.jokers) and {
				{
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes = {
						{
							n = G.UIT.C,
							config = {
								ref_table = card,
								align = "m",
								colour = G.C.JOKER_GREY,
								r = 0.05,
								padding = 0.06,
								func = "blueprint_compat",
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										ref_table = card.ability,
										ref_value = "blueprint_compat_ui",
										colour = G.C.UI.TEXT_LIGHT,
										scale = 0.32 * 0.8,
									},
								},
							},
						},
					},
				},
			} or nil,
		}
	end,
	update = function(self, card, dt)
		if G.STAGE == G.STAGES.RUN then
			--- @type SMODS.Joker
			local other_joker = G.jokers.cards[1]

			if other_joker and other_joker ~= card then
				if other_joker.add_to_deck ~= nil and type(other_joker.add_to_deck) == "function" then
					card.ability.blueprint_compat = "compatible"
				else
					card.ability.blueprint_compat = "incompatible"
				end
			else
				card.ability.blueprint_compat = "incompatible"
			end
		end
	end,
	calculate = function(self, card, context)
		--- @type SMODS.Joker
		local leftmost_joker = G.jokers.cards[1]

		if context.end_of_round and context.main_eval and not context.blueprint then
			if
				leftmost_joker.add_to_deck ~= nil
				and type(leftmost_joker.add_to_deck) == "function"
				and leftmost_joker.added_to_deck
			then
				--- @diagnostic disable-next-line: inject-field
				leftmost_joker.added_to_deck = false
				leftmost_joker:add_to_deck(card, false)

				return {
					message = "R o t o s c o p e d",
					card = leftmost_joker,
				}
			end
		end
	end,
})
