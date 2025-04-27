SMODS.Back {
    key = "tempered_glass_deck",
    atlas = "enhancements",
    pos = {
        x = 0,
        y = 0
    },
    loc_txt = {
        ["en-us"] = {
            name = "Tempered Glass Deck",
            text = {
                "Start with a Negative {C:attention}Probably Not{}",
                "and a deck full of {C:inactive}Glass{} cards"
            }
        }
    },
    apply = function(self, back)
        G.E_MANAGER:add_event(Event {
            func = function()
                for c = #G.playing_cards, 1, -1 do
                    G.playing_cards[c]:set_ability("m_glass")
                end

                return true
            end
        })

        G.E_MANAGER:add_event(Event {
            func = function()
                local prob_not = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_bearo_probablynot", nil)
                prob_not:set_edition({ negative = true })
                prob_not:add_to_deck()
                prob_not:start_materialize()
                G.jokers:emplace(prob_not)

                return true
            end
        })
    end
}
