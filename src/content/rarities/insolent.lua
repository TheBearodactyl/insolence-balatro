SMODS.Rarity {
    key = "insolent",
    loc_txt = {
        name = "Insolent."
    },
    prefix_config = {
        key = false,
    },
    badge_colour = G.C.PURPLE,
    get_weight = function(self, weight, object_type)
        if G.GAME.round_resets.ante > 39 then
            return 1
        else
            return 0
        end
    end
}