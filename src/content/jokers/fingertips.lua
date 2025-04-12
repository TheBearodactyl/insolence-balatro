--- @diagnostic disable: duplicate-set-field

G.FUNCS.can_play = function(e)
    if #G.hand.highlighted <= 0 or G.GAME.blind.block_play then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.BLUE
        e.config.button = 'play_cards_from_highlighted'
    end
end

SMODS.Joker {
    key = "fingertips",
    config = {
        extra = 2
    },
    rarity = 3,
    pos = {
        x = 5,
        y = 0
    },
    atlas = "jokers",
    cost = 5,
    order = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    soul_pos = nil,
    loc_txt = {
        ["en-us"] = {
            name = "F I N G E R T I P S",
            text = {
                "Increases card",
                "selection limit by {C:green}#1#{}"
            }
        }
    },
    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                center.ability.extra
            }
        }
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra = math.floor(card.ability.extra)
        G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + card.ability.extra
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand.config.highlighted_limit = G.hand.config.highlighted_limit - card.ability.extra

        if G.hand.config.highlighted_limit < 5 then
            G.hand.config.highlighted_limit = 5
        end

        if not G.GAME.before_play_buffer then
            G.hand:unhighlight_all()
        end
    end,
}
