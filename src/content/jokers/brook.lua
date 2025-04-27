SMODS.Joker {
    key = "brook",
    rarity = "strawhat",
    pos = { x = 3, y = 0 },
    atlas = "jokers",
    cost = 100,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    order = 7,
    soul_pos = { x = 15, y = 0 },
    config = {},
    loc_txt = {
        ["en-us"] = {
            name = "Brook",
            text = {
                "{X:gold,C:white}death.{}"
            }
        }
    },
    calculate = function(self, card, context)
        if context.game_over and G.GAME.chips / G.GAME.blind.chips >= to_big(0.25) then
            return {
                saved = true,
                message = localize("k_saved_ex"),
                colour = G.C.RED
            }
        end
    end,
}
