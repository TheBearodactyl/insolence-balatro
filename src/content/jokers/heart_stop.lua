BEARO.JOKERS.stopped_heart = SMODS.Joker {
    key = "heart_stop",
    config = {
        extra = {
            x_mult_mod = 0.75,
            reset_chance = 5,
            x_mult = 1
        }
    },
    rarity = 3,
    pos = { x = 0, y = 0 },
    atlas = "jokers",
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    soul_pos = nil,
    loc_vars = function(self, info_queue, card)
        local chance = function()
            if not BEARO.UTILS.is_rigged_cryptid(card) and G.GAME.probabilities.normal then
                return G.GAME.probabilities.normal
            elseif not BEARO.UTILS.is_rigged_cryptid(card) then
                return 1
            else
                return card.ability.extra.reset_chance
            end
        end

        return {
            vars = {
                card.ability.extra.x_mult_mod,
                chance(),
                card.ability.extra.x_mult,
                card.ability.extra.reset_chance
            }
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            if G.GAME.blind.boss and not (pseudorandom("Stopped Heart") < G.GAME.probabilities.normal / card.ability.extra.reset_chance) then
                card.ability.extra.x_mult = 1

                return {
                    message = localize("k_reset"),
                    colour = G.C.RED
                }
            else
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod

                return {
                    message = localize("k_upgrade_ex"),
                    colour = G.C.MULT,
                    card = card
                }
            end
        end

        if context.joker_main then
            if card.ability.extra.x_mult > 1 then
                return {
                    x_mult = card.ability.extra.x_mult,
                    card = card
                }
            end
        end
    end,
}

return BEARO.JOKERS.stopped_heart