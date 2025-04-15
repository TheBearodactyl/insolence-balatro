SMODS.Shader {
    key = "pinku",
    path = "pinku.fs"
}

SMODS.Edition {
    key = "pinku_ed",
    shader = "pinku",
    config = {
        extra = 1.5
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.extra
            }
        }
    end,
    loc_txt = {
        ["en-us"] = {
            name = "Pinku",
            label = "Filthy",
            text = {
                "Increases rank of played {C:attention}Pinku{} cards by {C:blue}+2{}",
                "then remove the {C:attention}Pinku{} edition"
            }
        }
    },
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            if card and card.base.id then
                assert(SMODS.modify_rank(card, 1))
            end
        end
    end
}