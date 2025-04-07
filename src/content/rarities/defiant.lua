local defiant_gradient = BEARO.UTILS.create_gradient(
    "defiant_grad",
    {
        HEX("ff03ff"),
        HEX("000000"),
        HEX("00ff00")
    }
)

SMODS.Rarity {
    key = "defiant",
    prefix_config = {
        key = false,
    },
    badge_colour = defiant_gradient,
    get_weight = function(self, weight, object_type)
        if G.GAME.round_resets.ante > 42 then
            return 0.0005
        else
            return 0
        end
    end
}
