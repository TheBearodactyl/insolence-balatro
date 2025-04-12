---@diagnostic disable: duplicate-set-field

SMODS.Shader {
    key = "trans",
    path = "trans.fs"
}

SMODS.Edition {
    key = "trans_ed",
    shader = "trans",
    config = {
        extra = {
            xmult = 1,
            xmult_mod = 0.25
        }
    },
    loc_txt = {
        ["en-us"] = {
            name = "Trans",
            label = "Trans!",
            text = {
                "This Edition gains {X:red,C:white}X#1#{} mult",
                "when changing suit.",
                "Resets at end of round",
                "{C:inactive}(Currently {X:red,C:white}X#2#{}){}"
            }
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
    calculate = function(self, card, context)
        --- @type string
        local curr_suit = card.base.suit

        if context.using_consumeable then
            if context.consumeable.ability.name == "The Sun"
                or context.consumeable.ability.name == "The Moon"
                or context.consumeable.ability.name == "The Star"
                or context.consumeable.ability.name == "The World"
                or context.consumeable.ability.name == "Sigil"
            then
                local msg = ""
                local new_suit = ""

                if context.consumeable.ability.name == "The Sun" then
                    msg = curr_suit:sub(1, 1) .. "t" .. "H"
                    new_suit = "H"
                elseif context.consumeable.ability.name == "The Moon" then
                    msg = curr_suit:sub(1, 1) .. "t" .. "C"
                    new_suit = "C"
                elseif context.consumeable.ability.name == "The World" then
                    msg = curr_suit:sub(1, 1) .. "t" .. "S"
                    new_suit = "S"
                elseif context.consumeable.ability.name == "The Star" then
                    msg = curr_suit:sub(1, 1) .. "t" .. "D"
                    new_suit = "D"
                else
                    msg = BEARO.UTILS.choose_rand({ "MtF", "FtM" })
                end

                if curr_suit:sub(1, 1) ~= new_suit then
                    local curr_xmult = self.config.extra.xmult
                    self.config.extra.xmult = curr_xmult + self.config.extra.xmult_mod
                end

                msg = msg .. " \n(" .. self.config.extra.xmult .. ")"

                return {
                    message = msg
                }
            else
                return {
                    message = "Nice try."
                }
            end
        end

        if context.cardarea == G.play and context.main_scoring and not context.repetition then
            return {
                Xmult_mod = self.config.extra.xmult,
                message = "Thank Blahaj",
                card = card,
            }
        end

        if context.end_of_round and context.blind.boss then
            self.config.extra.xmult = 1.0
        end
    end
}

local orig_change_suit = Card.change_suit
--- @param self Card
--- @param new_suit string
function Card:change_suit(new_suit)
    if self.edition and self.edition.key == "e_bearo_trans_ed" then
        if self.config.extra and self.config.extra.xmult and self.config.extra.xmult_mod then
            local curr_xmult = self.config.extra.xmult

            self.config.extra.xmult = curr_xmult + self.config.extra.xmult_mod
        end
    end

    orig_change_suit(self, new_suit)
end
