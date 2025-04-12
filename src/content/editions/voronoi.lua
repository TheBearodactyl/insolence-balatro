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
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        if G.deck then
            return {
                vars = {
                    math.floor(#G.deck.cards / 2)
                }
            }
        else
            return {
                vars = {
                    0
                }
            }
        end
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and G.deck and context.main_scoring and not context.repetition then
            return {
                message = "fractal",
                card = card,
                mult_mod = math.floor(#G.deck.cards / 2)
            }
        end
    end
}
