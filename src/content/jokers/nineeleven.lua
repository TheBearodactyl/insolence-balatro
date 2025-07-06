SMODS.Joker {
    key = "nineeleven",
    atlas = "jokers",
    pos = {
        x = 5,
        y = 1
    },
    config = {
        extra = {
            mult_mod = 7,
            mult = 0
        }
    },
    loc_txt = {
        ["en-us"] = {
            name = "9/11",
            text = {
                "Destroys all {C:attention}Towers{}",
                "in your {C:attention}consumable slot{}",
                "at the end of round.",
                "Gains {C:mult}+#1#{} Mult for every",
                "destroyed {C:attention}Tower{}",
                "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["c_tower"]

        return {
            vars = {
                self.config.extra.mult_mod,
                self.config.extra.mult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.blueprint then
            if G.consumeables then
                for _, v in pairs(G.consumeables.cards) do
                    --- @type Card
                    v = v

                    if v.ability.name == "The Tower" then
                        self.config.extra.mult = self.config.extra.mult + self.config.extra.mult_mod

                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:start_dissolve()
                                G.consumeables:remove_card(v)
                                v:remove()
                                v = nil

                                return true
                            end
                        }))
                    end
                end

                return {
                    message = "*ominous whispers*",
                    colour = G.C.YELLOW
                }
            end
        end


        if context.joker_main and context.cardarea == G.jokers then
            return {
                mult = self.config.extra.mult,
                message = "Sir, a second plane has hit the towers"
            }
        end
    end
}
