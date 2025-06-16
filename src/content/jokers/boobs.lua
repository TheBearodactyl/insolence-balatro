SMODS.Joker {
    key = "boobs",
    atlas = "jokers",
    pos = { x = 12, y = 0 },
    soul_pos = libinsolence.boobs_sprite(SMODS.current_mod),
    order = 70,
    rarity = 3,
    cost = 7,
    config = {
        extra = {
            chips = 80
        }
    },
    loc_txt = {
        ["en-us"] = {
            name = "A BOOB! WOW!",
            text = {
                "Gives {C:chips}+#1#{} chips",
                "Increases to {C:chips}+8008{} if 2 boobs are owned"
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips
            }
        }
    end,
    update = function(self, card, dt)
        if libinsolence.count_num_of_joker("ins", "boobs") >= 2 then
            card.ability.extra.chips = 8008
        else
            card.ability.extra.chips = 80
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = "(. Y .)",
                chips = card.ability.extra.chips,
                card = card
            }
        end
    end
}

local orig_gup = Game.update
function Game:update(dt)
    orig_gup(self, dt)

    if G.P_CENTERS and G.P_CENTERS.j_ins_boobs then
        if insolence.mod.config and insolence.mod.config.adult_mode == true then
            G.P_CENTERS.j_ins_boobs.soul_pos = { x = 10000000, y = 100000000 }
        elseif insolence.mod.config.adult_mode == false then
            G.P_CENTERS.j_ins_boobs.soul_pos = { x = 12, y = 2 }
        end
    end
end
