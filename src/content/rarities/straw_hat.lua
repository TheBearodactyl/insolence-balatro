local strawhat_gradient = BEARO.UTILS.create_gradient("strawhat_gradient", {
	HEX("9be394"),
	HEX("d85242"),
})

SMODS.Rarity({
	key = "strawhat",
	prefix_config = {
		key = false,
	},
	badge_colour = strawhat_gradient,
	get_weight = function(self, weight, object_type)
		if G.GAME.round_resets.ante > 100 then
			return 0.0005
		else
			return 0
		end
	end,
})
