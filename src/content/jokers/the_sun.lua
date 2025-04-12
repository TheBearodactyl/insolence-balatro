SMODS.Joker {
    key = "the_sun",
    config = {
        extra = {
            x_mult = 1,
            upgrade_chance = 2,
            upgrade_mod = 1,
        }
    },
    rarity = 4,
    pos = { x = 1, y = 0 },
    atlas = "jokers",
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    soul_pos = { x = 2, y = 0 },
    loc_txt = {
        ["en-us"] = {
            name = "A Nice Day Out",
            text = {
                "{C:green}#2#{} in {C:green}#3#{} chance to",
                "gain {X:red,C:white}X#4#{} mult at the",
                "end of round",
                "{C:inactive}(Currently {}{X:red,C:white}X#1#{}{C:inactive} Mult){}"
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        local chance = function()
            if not BEARO.UTILS.is_rigged_cryptid(card) and G.GAME.probabilities.normal then
                return G.GAME.probabilities.normal
            elseif not BEARO.UTILS.is_rigged_cryptid(card) then
                return 1
            else
                return card.ability.extra.upgrade_chance
            end
        end

        return {
            vars = {
                card.ability.extra.x_mult,
                chance(),
                card.ability.extra.upgrade_chance,
                card.ability.extra.upgrade_mod
            }
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint and (pseudorandom("Pebbles") < G.GAME.probabilities.normal / 2 or BEARO.UTILS.is_rigged_cryptid(card)) then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.upgrade_mod

            return {
                message = localize("k_upgrade_ex"),
                colour = G.C.RED
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
