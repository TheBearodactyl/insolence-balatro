SMODS.Joker {
    key = "entropy",
    config = {
        extra = {
            x_mult = 2,
        }
    },
    rarity = "insolent",
    pos = { x = 3, y = 0 },
    atlas = "jokers",
    cost = 100,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    order = 4,
    eternal_compat = false,
    perishable_compat = false,
    soul_pos = { x = 4, y = 0 },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            local curr_x_mult = card.ability.extra.x_mult
            card.ability.extra.x_mult = card.ability.extra.x_mult + curr_x_mult + curr_x_mult

            return {
                message = "oh shit oh fuck (X" .. card.ability.extra.x_mult .. ")",
                colour = G.C.MULT,
                card = G.hand.highlighted[1]
            }
        end

        if context.joker_main then
            if card.ability.extra.x_mult > 1 then
                return {
                    x_mult = card.ability.extra.x_mult,
                    card = card
                }
            end
        end
    end
}
