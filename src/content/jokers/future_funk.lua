SMODS.Joker {
    key = "futurefunk",
    atlas = "futurefunkanim",
    pos = {
        x = 0,
        y = 0
    },
    rarity = 2,
    loc_txt = {
        ["en-us"] = {
            name = "What is a Future Funk?",
            text = {
                "Every #1# hands:",
                "{C:green}#2#%{} chance to give {X:planet,C:white,s:3}^#3#{} Mult",
                "{C:green}#4#%{} chance to {C:attention}halve{} {C:chips}chips{} and {C:mult}mult{} of played hand",
                "",
                "{C:inactive}(#5#){}"
            }
        }
    },
    config = {
        extra = {
            every_other = 3,
            expo_mult_percent = 10,
            expo_mult = 5,
            active = false,
            blind_counter = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.extra.every_other,
                self.config.extra.expo_mult_percent,
                self.config.extra.expo_mult,
                100 - self.config.extra.expo_mult_percent,
                self.config.extra.active and "active" or "inactive"
            }
        }
    end,
    calculate = function(self, card, context)
        if context.press_play then
            self.config.extra.blind_counter = self.config.extra.blind_counter + 1
        end

        self.config.extra.active = (self.config.extra.blind_counter % 3) == 0

        if context.joker_main and context.cardarea == G.jokers and self.config.extra.active then
            if pseudorandom("Future Funk", 1, 100) <= self.config.extra.expo_mult_percent then
                return {
                    Emult_mod = self.config.extra.expo_mult,
                    card = card,
                    message = "GG"
                }
            else
                return {
                    message = "RIP :(",
                    card = card,
                    Xmult_mod = 0.5,
                    Xchip_mod = 0.5
                }
            end
        end
    end
}