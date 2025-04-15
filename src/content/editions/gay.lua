SMODS.Shader {
    key = "gay",
    path = "gay.fs"
}

SMODS.Edition {
    key = "gay_ed",
    shader = "gay",
    disable_shadow = true,
    config = {
        extra = 2
    },
    loc_txt = {
        ["en-us"] = {
            name = "Gay",
            label = "GAYYYYYYY",
            text = {
                "Gives {X:red,C:white}X#1#{} mult when played",
                "with another {C:red}G{}{C:green}a{}{C:blue}y{} card."
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.extra
            }
        }
    end,
    on_apply = function(self)
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            local gay_count = 0

            for _, v in pairs(
            --- @type CalcContext | (Card[] | table[])
                context.scoring_hand
            ) do
                local ed = v.edition and v.edition or {}

                if ed.key and ed.key == "e_bearo_gay_ed" then
                    gay_count = gay_count + 1
                end
            end

            if gay_count > 1 then
                return {
                    Xmult_mod = self.config.extra,
                    message = "HA! GAYYYYY!",
                    card = card,
                }
            else
                return {
                    message = "i am lonely :(",
                    card = card,
                }
            end
        end
    end
}