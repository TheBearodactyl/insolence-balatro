-- ripped from cryptid lmao
SMODS.Consumable({
	key = "conduit",
	atlas = "consumables",
	loc_txt = {
		["en-us"] = {
			name = "Electrified Bathtub",
			text = {
				"Swap the {C:attention}editions{} of {C:green}2{}",
				"selected cards or {C:attention}Jokers{}",
				'{C:inactive}Diane: "we\'ve swapped personalities Frank!"{}',
				'{C:inactive}Frank: "Diane!!! I\'ve got boobies now!!!"{}',
			},
		},
	},
	pos = { x = 0, y = 0 },
	config = {},
	cost = 4,
	set = "Spectral",
	order = 12,
	can_use = function(self, card)
		local combined_table = {}

		for _, v in ipairs(G.hand.highlighted) do
			if v ~= card then
				table.insert(combined_table, v)
			end
		end

		for _, v in ipairs(G.jokers.highlighted) do
			if v ~= card then
				table.insert(combined_table, v)
			end
		end

		return (#combined_table == 2)
	end,
	use = function(self, card, area, copier)
		local used_consumable = copier or card
		local combined_table = {}

		for _, value in ipairs(G.hand.highlighted) do
			if value ~= card then
				table.insert(combined_table, value)
			end
		end

		for _, value in ipairs(G.jokers.highlighted) do
			if value ~= card then
				table.insert(combined_table, value)
			end
		end

		local highlighted_one = combined_table[1]
		local highlighted_two = combined_table[2]

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("tarot1")
				used_consumable:juice_up(0.3, 0.5)
				return true
			end,
		}))

		local percent = 1.15 - (1 - 0.999) / (1 - 0.998) * 0.3

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.15,
			func = function()
				highlighted_one:flip()
				highlighted_two:flip()

				play_sound("card1", percent)

				highlighted_one:juice_up(0.3, 0.3)
				highlighted_two:juice_up(0.3, 0.3)

				return true
			end,
		}))

		delay(0.2)

		local percent = 0.85 + (1 - 0.999) / (1 - 0.998) * 0.3

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.15,
			func = function()
				local one_edition = highlighted_one.edition
				highlighted_one:flip()
				highlighted_one:set_edition(highlighted_two.edition)
				highlighted_two:flip()
				highlighted_two:set_edition(one_edition)

				play_sound("card1", percent)

				highlighted_one:juice_up(0.3, 0.3)
				highlighted_two:juice_up(0.3, 0.3)

				return true
			end,
		}))

		delay(0.2)

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("tarot2")
				used_consumable:juice_up(0.3, 0.5)
				return true
			end,
		}))

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				G.jokers:unhighlight_all()

				return true
			end,
		}))
	end,
})
