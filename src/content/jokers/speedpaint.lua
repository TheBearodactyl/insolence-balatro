SMODS.Joker {
    key = "speedpaint",
    atlas = "speedpaintanim",
    pos = {
        x = 0,
        y = 0
    },
    rarity = 2,
    config = {
        extra = {
            xmult = 1,
            xmult_per_handsize = 0.5,
            min_size = 4
        }
    },
    loc_txt = {
        ["en-us"] = {
            name = "Speedpaint",
            text = {
                "Gives {X:mult,C:white}X#1#{} Mult for each",
                "handsize above {C:blue}#2#{}",
                "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)"
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.extra.xmult_per_handsize,
                self.config.extra.min_size,
                self.config.extra.xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if G.hand then
            local curr_handsize = G.hand and G.hand.config.card_limit or 4
            self.config.extra.xmult = (curr_handsize - self.config.extra.min_size) * self.config.extra.xmult_per_handsize

            if context.joker_main and not context.repetition then
                return {
                    Xmult_mod = self.config.extra.xmult,
                    message = "Painted!"
                }
            end
        end
    end
}
