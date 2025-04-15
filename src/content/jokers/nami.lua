SMODS.Joker {
    key = "nami",
    rarity = "strawhat",
    pos = { x = 3, y = 0 },
    atlas = "jokers",
    cost = 100,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    order = 6,
    soul_pos = { x = 13, y = 0 },
    config = {},
    loc_txt = {
        ["en-us"] = {
            name = "Nami",
            text = {
                "{X:gold,C:white}tangerines.{}",
                "{C:inactive}(Gives dollar bonus equal to Hands Played times PI){}"
            }
        }
    },
    calc_dollar_bonus = function(self, card)
        return G.GAME.hands_played * math.ceil(math.pi)
    end
}
