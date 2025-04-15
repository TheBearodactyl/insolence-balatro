SMODS.Shader {
    key = "voronoi",
    path = "voronoi.fs"
}

SMODS.Edition {
    key = "voronoi_ed",
    shader = "voronoi",
    loc_txt = {
        ["en-us"] = {
            name = "Voronoi",
            label = "Ever Changing",
            text = {
                "Gives {C:red}+#1#{} mult",
                "{C:inactive}(Gives the number of {C:attention}Cards{}{C:inactive} in {C:attention}Deck{}{C:inactive} divided by {C:green}PI{}{C:inactive}){}"
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        if G.deck then
            return {
                vars = {
                    #G.deck.cards / 3.14159265359
                }
            }
        else
            return {
                vars = {
                    52 / 3.14159265359
                }
            }
        end
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and G.deck and context.main_scoring and not context.repetition then
            return {
                message = "E v e r C h a n g i n g",
                card = card,
                mult_mod = #G.deck.cards / 3.14159265359
            }
        end
    end
}
