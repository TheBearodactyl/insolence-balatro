SMODS.Back {
    key = "cloud_deck",
    atlas = "jokers",
    discovered = true,
    unlocked = true,
    pos = {
        x = 0,
        y = 0
    },
    loc_txt = {
        ["en-us"] = {
            name = "Deck of Clouds",
            text = {
                "Start with a deck full of 9s",
                "and a Cloud 9"
            }
        }
    },
    apply = function(self, back)
        G.E_MANAGER:add_event(Event {
            func = function()
                for c = #G.playing_cards, 1, -1 do
                    --- @type Card
                    local card = G.playing_cards[c]
                    local suit_prefix = string.sub(card.base.suit, 1, 1) .. '_'

                    card:set_base(G.P_CARDS[suit_prefix .. '9'])
                end

                return true
            end
        })
    end
}
