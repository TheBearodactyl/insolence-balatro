SMODS.Rarity({
    key = "strawhat",
    prefix_config = {
        key = false,
    },
    badge_colour = HEX("9be394"),
    get_weight = function(self, weight, object_type)
        if G.GAME.round_resets.ante > 100 then
            return 0.0005
        else
            return 0
        end
    end,
})
