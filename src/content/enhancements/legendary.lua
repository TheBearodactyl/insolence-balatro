BEARO.legendary_enh = SMODS.Enhancement {
    key = "legendary_enh",
    atlas = "legendary",
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            chance = 0.03,
            emult = 2
        }
    },
    loc_txt = {
        ["en-us"] = {
            name = "Legendary",
            text = {
                "Has a {C:green}#1#%{} percent chance of giving {X:planet,C:white}^#2#{} Mult."
            }
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.extra.chance,
                self.config.extra.emult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            if BEARO.UTILS.chance(self.config.extra.chance) == true then
                return {
                    emult = self.config.extra.emult,
                    message = "LEGENDARY",
                    card = card
                }
            else
                return {
                    message = localize("k_nope_ex")
                }
            end
        end
    end
}