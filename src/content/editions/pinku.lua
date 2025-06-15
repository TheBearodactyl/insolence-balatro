SMODS.Shader {
    key = "pinku",
    path = "pinku.fs"
}

SMODS.Edition {
    key = "pinku_ed",
    shader = "pinku",
    config = {
        extra = {
            xmult_mod = 1,
            xmult = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.extra.xmult_mod,
                self.config.extra.xmult
            }
        }
    end,
    loc_txt = {
        ["en-us"] = {
            name = "Pinku",
            label = "Filthy",
            text = {
                "Gives {X:mult,C:white}X#1#{} Mult for",
                "each owned {C:attention}Chromosome{}",
                " ",
                "{C:inactive}(Currently gives {}{X:mult,C:white}X#2#{}{C:inactive} Mult){}"
            }
        }
    }
}