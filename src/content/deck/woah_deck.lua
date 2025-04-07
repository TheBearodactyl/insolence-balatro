SMODS.Back {
    key = "woah_deck",
    atlas = "enhancements",
    pos = {
        x = 0,
        y = 0,
    },
    apply = function(self, back)
        G.E_MANAGER:add_event(Event {
            func = function()
                for c = #G.playing_cards, 1, -1 do
                    G.playing_cards[c]:set_ability("m_bearo_woah_enh")
                end
                return true
            end
        })
    end
}