SMODS.Shader {
    key = "digitalink",
    path = "digitalink.fs"
}

SMODS.Joker {
    key = "printerink",
    atlas = "jokers",
    pos = { x = 3, y = 1 },
    cost = 7,
    rarity = 3,
    loc_txt = {
        ["en-us"] = {
            name = "Printer Ink Joker",
            text = {
                "All cards are all suits"
            }
        }
    },
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader("ins_digitalink", nil, card.ARGS.send_to_shader)
        end
    end
}

local orig_cis = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    local ret = orig_cis(self, suit, bypass_debuff, flush_calc)

    if libinsolence.count_num_of_joker("ins", "printerink") >= 1 then
        return true
    end

    return ret
end
