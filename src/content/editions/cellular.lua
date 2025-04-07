SMODS.Shader {
    key = "cellular",
    path = "cellular.fs"
}

SMODS.Sound {
    key = "cellulite_apply",
    path = "cellulite_apply.ogg",
}

SMODS.Sound {
    key = "mitosis",
    path = "mitosis.ogg"
}

SMODS.Edition {
    key = "cellular_ed",
    shader = "cellular",
    config = {
        extra = {
            dupes = 1
        }
    },
    loc_txt = {
        ["en-us"] = {
            label = "Cellulite!"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.extra.dupes
            }
        }
    end,
    sound = {
        sound = "bearo_cellulite_apply"
    },
    disable_base_shader = true,
    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_played == 0 and not context.repetition and context.cardarea == G.play then
            if #context.scoring_hand == 1 then
                -- G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local _card = copy_card(context.scoring_hand[1], nil, nil, G.playing_card)
                _card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, _card)
                G.hand:emplace(_card)
                _card.states.visible = nil

                G.E_MANAGER:add_event(Event {
                    func = function()
                        _card:start_materialize()
                        play_sound("bearo_mitosis", 1, 2)
                        return true
                    end,
                })

                return {
                    message = localize("k_mitosis_ex"),
                    colour = G.C.CHIPS,
                    card = self,
                    playing_cards_created = { true }
                }
            end
        end
    end,
}