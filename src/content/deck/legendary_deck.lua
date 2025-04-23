SMODS.Back {
    key = "legendary_deck",
    atlas = "legendary",
    discovered = true,
    unlocked = true,
    pos = {
        x = 0,
        y = 0,
    },
    loc_txt = {
        ["en-us"] = {
            name = "Legendary Deck",
            text = {
                "All cards have the {C:attention}Legendary{} enhancement"
            }
        }
    },
    apply = function(self, back)
        G.E_MANAGER:add_event(Event {
            func = function()
                for c = #G.playing_cards, 1, -1 do
                    G.playing_cards[c]:set_ability("m_bearo_legendary_enh")
                end
                return true
            end
        })
    end
}