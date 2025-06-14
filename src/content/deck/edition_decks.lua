local eds = {
	"ace",
	"aurora",
	"bisexual",
	"bocchi",
	"bubbly",
	"bugged",
	"cellular",
	"printerink",
	"edgy",
	"equalize",
	"gay",
	"lesbian",
	"lightshow",
	"pinku",
	"tiled",
	"trans",
	"universe",
	"vaporwave",
	"voronoi",
	"wavy",
}

for _, v in pairs(eds) do
	local deck_key = v .. "_deck"
	local edit_key = "e_bearo_" .. v .. "_ed"

	SMODS.Back({
		key = deck_key,
		atlas = "jokers",
		pos = insolib.placeholder_sprite(),
		discovered = true,
		loc_txt = {
			["en-us"] = {
				name = insolib.capitalize(v) .. " Deck",
				text = {
					"A deck made up entirely of",
					insolib.capitalize(v) .. " cards",
				},
			},
		},
		unlocked = true,
		apply = function(self, back)
			G.E_MANAGER:add_event(Event({
				func = function()
					for c = #G.playing_cards, 1, -1 do
						G.playing_cards[c]:set_edition(edit_key, true, true)
					end

					return true
				end,
			}))
		end,
	})
end

SMODS.Back({
	key = "bugged_deck",
	atlas = "jokers",
	pos = { x = 1, y = 0 },
	discovered = true,
	loc_txt = {
		["en-us"] = {
			name = "Bugged Deck",
			text = {
				"A deck made up entirely of",
				"Bugged cards",
			},
		},
	},
	unlocked = true,
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				for c = #G.playing_cards, 1, -1 do
					G.playing_cards[c]:set_edition("e_bearo_bugged_ed", true, true)
				end

				G.GAME.starting_params.joker_slots = 0

				return true
			end,
		}))
	end,
})
