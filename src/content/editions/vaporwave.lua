SMODS.Shader {
    key = "vaporwave",
    path = "vaporwave.fs"
}

SMODS.Edition {
    key = "vaporwave_ed",
    shader = "vaporwave",
    disable_base_shader = true,
    config = {
        extra = 1.2,
    },
    loc_txt = {
        ["en-us"] = {
            name = "Vaporwave",
            label = "Vaporwave",
            text = {
                "Gives {X:blue,C:white,s:3}^#1#{} mult"
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
    calculate = function (self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            return {
                emult = self.config.extra
            }
        elseif context.joker_main then
            return {
                emult = self.config.extra
            }
        end
    end
}