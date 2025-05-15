SMODS.Consumable({
	key = "the_borealis",
	atlas = "consumables",
	pos = { x = 7, y = 0 },
	config = {},
	cost = 5,
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_set = "Tarot",
	soul_rate = 0.05,
	set = "Spectral",
	order = 14,
	loc_txt = {
		["en-us"] = {
			name = "The Borealis",
			text = {
				"Adds {C:attention}Aurora{} to {C:green}1{} selected {C:attention}playing card{}",
			},
		},
	},
	can_use = function(self, card)
		return (#G.hand.highlighted == 1)
	end,
	use = function(self, card, area, copier)
		local used_consumable = copier or card
		local aaaaaa = {}

		for _, value in ipairs(G.hand.highlighted) do
			if value ~= card then
				table.insert(aaaaaa, value)
			end
		end

		local selected_card = aaaaaa[1]

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
				selected_card:flip()

				play_sound("card1", percent)

				selected_card:juice_up(0.3, 0.3)

				return true
			end,
		}))

		delay(0.2)

		local percent = 0.85 + (1 - 0.999) / (1 - 0.998) * 0.3

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.15,
			func = function()
				local one_edition = selected_card.edition
				selected_card:flip()
				selected_card:set_edition({ bearo_aurora_ed = true })

				play_sound("card1", percent)

				selected_card:juice_up(0.3, 0.3)

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
