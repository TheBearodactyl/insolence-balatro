SMODS.Joker {
    key = "metroman",
    atlas = "metroman",
    pos = { x = 0, y = 0 },
    rarity = "insolent",
    blueprint_compat = false,
    cost = 100,
    loc_txt = {
        ["en-us"] = {
            name = "{X:gold,C:white}M{X:white,C:gold}e{X:gold,C:white}t{X:white,C:gold}r{X:gold,C:white}o{X:white,C:gold}m{X:gold,C:white}a{X:white,C:gold}n{}",
            text = {
                "{X:gold,C:white}speed.{}",
                "{C:inactive}(Auto-sorts your jokers :3){}"
            }
        }
    },
    calculate = function(self, card, context)
        -- local sorted_jokers = BEARO.UTILS.sort_jokers(context)
    end,
}
