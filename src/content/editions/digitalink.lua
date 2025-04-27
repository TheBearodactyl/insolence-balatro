SMODS.Shader {
    key = "digitalink",
    path = "digitalink.fs"
}

local printer_msgs = {
    { string = "When playing 3 or more cards,", G.C.BLACK },
    { string = "convert all Printer Ink cards", G.C.BLACK },
    { string = "into the most used suit in",    G.C.BLACK },
    { string = "played hand.",                  G.C.BLACK },
}

SMODS.Edition {
    key = "digitalink_ed",
    shader = "digitalink",
    loc_txt = {
        ["en-us"] = {
            name = "Printer Ink",
            label = "Grainy and Smeared",
            text = { "" }
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            main_start = {
                BEARO.UTILS.cycling_text(printer_msgs, false, 1, 0.5)
            }
        }
    end,
    calculate = function(self, card, context)
        if context.full_hand and #context.full_hand >= 3 then
            local suits = {
                clubs = 0,
                spades = 0,
                hearts = 0,
                diamonds = 0,
            }

            for k, v in pairs(context.full_hand) do
                if v:is_suit("Clubs") then
                    suits.clubs = suits.clubs + 1
                elseif v:is_suit("Hearts") then
                    suits.hearts = suits.hearts + 1
                elseif v:is_suit("Spades") then
                    suits.spades = suits.spades + 1
                elseif v:is_suit("Diamonds") then
                    suits.diamonds = suits.diamonds + 1
                end
            end

            local majority_suit = BEARO.UTILS.largest_val(suits)

            --- @type string
            local new_suit = BEARO.UTILS.match(majority_suit, {
                ["clubs"] = "Clubs",
                ["spades"] = "Spades",
                ["hearts"] = "Hearts",
                ["diamonds"] = "Diamonds"
            })

            card:change_suit(new_suit)
        end
    end,
}
