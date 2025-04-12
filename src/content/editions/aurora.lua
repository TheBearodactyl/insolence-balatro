SMODS.Shader {
    key = "aurora",
    path = "aurora.fs"
}

SMODS.Edition {
    key = "aurora_ed",
    shader = "aurora",
    config = {
        extra = 1.02
    },
    loc_txt = {
        ["en-us"] = {
            name = "Aurora",
            label = "Aurora Borealis",
            text = {
                "Gives {X:planet,C:white,s:5,E:1}^^#1#{} mult."
            }
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.extra
            }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            return {
                eemult = self.config.extra
            }
        end
    end
}