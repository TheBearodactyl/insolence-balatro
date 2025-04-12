SMODS.Shader {
    key = "ace",
    path = "ace.fs"
}

SMODS.Edition {
    key = "ace_ed",
    shader = "ace",
    config = {
        extra = {
            x_mult = 2
        }
    },
    loc_txt = {
        ["en-us"] = {
            name = "Asexual",
            label = "Asexual",
            text = {
                "Gives {X:red,C:white}X#1#{} {C:red}Mult{} if",
                "played with {C:green}1{} {C:attention}Ace of {C:red}Hearts{}",
                "or {C:attention}no other scoring cards{}"
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.extra.x_mult
            }
        }
    end,
    --- @param self table | SMODS.Center
    --- @param card table | Card
    --- @param context table | CalcContext
    calculate = function(self, card, context)
        if context.cardarea and context.main_scoring then
            --- @type boolean
            local has_ace_heart = false

            --- @type number
            local played_cards = 0

            for _, v in pairs(
            --- @type CalcContext | (Card[] | table[])
                context.scoring_hand
            ) do
                played_cards = BEARO.UTILS.inc(played_cards)

                if v.base.id == 14 and v.base.suit == "Hearts" then
                    has_ace_heart = true
                end
            end

            if (has_ace_heart and played_cards <= 2) or (played_cards == 1) then
                return {
                    Xmult_mod = self.config.extra.x_mult,
                    message = "ACE IN SPAAAAACE (great game btw)",
                    card = card
                }
            else
                return {
                    message = "nah.",
                    card = card
                }
            end
        end
    end
}
