SMODS.Shader({
    key = "bubbly",
    path = "bubbly.fs",
})

SMODS.Enhancement {
    key = "bubbly_enh",
    atlas = "jokers",
    pos = {
        x = 3,
        y = 1,
    },
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader("ins_bubbly", nil, card.ARGS.send_to_shader)
        end
    end,
    loc_txt = {
        ["en-us"] = {
            name = "Bubbly",
            label = "oOoOoOoOo",
            text = {
                "Gives {X:mult,C:white}X#1#{} Mult for each",
                "sold {C:attention}Wet Joker{} this run",
                " ",
                "{C:inactive}(Currently {}{X:mult,C:white}X#2#{}{C:inactive} Mult){}"
            }
        }
    },
    config = {
        extra = {
            xmult_mod = 0.15,
            xmult = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["j_splash"]
        info_queue[#info_queue + 1] = G.P_CENTERS["j_lusty_joker"]
        info_queue[#info_queue + 1] = G.P_CENTERS["j_diet_cola"]
        info_queue[#info_queue + 1] = G.P_CENTERS["j_selzer"]

        return {
            vars = {
                self.config.extra.xmult_mod,
                self.config.extra.xmult
            }
        }
    end,
    calculate = function(self, card, context)
        local bubbly_jokers = {
            "Splash",
            "Lusty Joker",
            "Diet Cola",
            "Seltzer"
        }

        local wet_joker = false

        for _, jk in ipairs(bubbly_jokers) do
            if context.card and context.card.ability.name == jk then
                wet_joker = true
            end
        end

        if (context.selling_card and wet_joker and not context.blueprint and not context.retrigger_joker) and not context.repetition and not context.individual then
            self.config.extra.xmult = self.config.extra.xmult + self.config.extra.xmult_mod

            return {
                message = localize("k_upgrade_ex"),
                card = context.card
            }
        end

        if context.main_scoring and context.cardarea == G.play then
            if self.config.extra.xmult > 1.0 then
                return {
                    Xmult_mod = self.config.extra.xmult,
                    message = "i am unda ze wata"
                }
            end
        end
    end
}