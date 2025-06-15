local editions = {
	"lesbian",
	"gay",
	"bisexual",
	"trans",
	"ace",
	"aurora",
	"bocchi",
	"bubbly",
	"bugged",
	"edgy",
	"equalize",
	"fractal",
	"kleinian",
	"lightshow",
	"synth",
	"vaporwave",
	"voronoi",
	"wavy",
}

for k, v in pairs(editions) do
	SMODS.Joker({
		name = insolib.capitalize(v),
		key = v .. "_joker",
		atlas = "jokers",
		rarity = 3,
		pos = {
			x = 4,
			y = 1,
		},
		loc_txt = {
			["en-us"] = {
				name = insolib.capitalize(v),
				text = {
					"A " .. insolib.capitalize(v) .. " Joker!",
				},
			},
		},
		draw = function(self, card, layer)
			if not card.edition then
				card:set_edition({ ["bearo_" .. v .. "_ed"] = true }, true, true)
			end

			if card.edition and not card.edition.key == "bearo_" .. v .. "_ed" then
				card:set_edition({ ["bearo_" .. v .. "_ed"] = true }, true, true)
			end
		end,
		update = function(self, card, dt)
			if not card.edition then
				card:set_edition({ ["bearo_" .. v .. "_ed"] = true }, true, true)
			end

			if card.edition and not card.edition.key == "bearo_" .. v .. "_ed" then
				card:set_edition({ ["bearo_" .. v .. "_ed"] = true }, true, true)
			end
		end,
	})
end
