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
                "Gives {C:red}+#1#{} mult and {C:blue}-#2#{} chips",
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        if G.deck then
            return {
                vars = {
                    math.abs(math.cos(#G.deck.cards / math.pi)),
                    -math.abs(math.sin(#G.deck.cards / math.pi))
                }
            }
        else
            return {
                vars = {
                    52 / math.pi
                }
            }
        end
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and G.deck and context.main_scoring and not context.repetition then
            return {
                message = "E v e r C h a n g i n g",
                card = card,
                mult_mod = math.abs(math.cos(#G.deck.cards / math.pi)),
                chips = -math.abs(math.sin(#G.deck.cards / math.pi))
            }
        end
    end
}
