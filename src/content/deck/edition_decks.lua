local eds = {
    "ace",
    "aurora",
    "bisexual",
    "bugged",
    "cellular",
    "digitalink",
    "edgy",
    "gay",
    "lesbian",
    "pinku",
    "trans",
    "vaporwave",
    "voronoi",
}

for _, v in pairs(eds) do
    local deck_key = v .. "_deck"
    local edit_key = "e_bearo_" .. v .. "_ed"

    SMODS.Back {
        key = deck_key,
        atlas = "jokers",
        pos = BEARO.UTILS.placeholder_sprite(),
        discovered = true,
        loc_txt = {
            ["en-us"] = {
                name = BEARO.UTILS.capitalize(v) .. " Deck",
                text = {
                    "A deck made up entirely of",
                    BEARO.UTILS.capitalize(v) .. " cards"
                }
            }
        },
        unlocked = true,
        apply = function(self, back)
            G.E_MANAGER:add_event(Event {
                func = function()
                    for c = #G.playing_cards, 1, -1 do
                        G.playing_cards[c]:set_edition(edit_key, true, true)
                    end

                    return true
                end
            })
        end
    }
end