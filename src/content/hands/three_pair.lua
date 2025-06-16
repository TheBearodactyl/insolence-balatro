local function eval_three_pair(parts, hand)
    if #parts._2 < 3 then
        return {}
    end

    return parts._all_pairs
end

SMODS.PokerHand({
    key = "three_pair",
    mult = 10,
    chips = 130,
    l_mult = 4,
    l_chips = 40,
    atlas = "jokers",
    visible = false,
    pos = libinsolence.placeholder_sprite(),
    example = {
        { "S_A", true },
        { "H_A", true },
        { "C_Q", true },
        { "D_Q", true },
        { "C_K", true },
        { "D_K", true },
    },
    loc_txt = {
        ["en-us"] = {
            name = "Three Pair",
            description = {
                "3 Pairs",
            },
        },
    },
    evaluate = function(parts, hand)
        return eval_three_pair(parts, hand)
    end,
})

SMODS.Planet({
    key = "planet_punpun",
    atlas = "planets",
    pos = {
        x = 0,
        y = 0,
    },
    unlocked = true,
    loc_txt = {
        ["en-us"] = {
            name = "Planet PunPun",
        },
    },
    in_pool = function(self)
        if G.GAME.hands["ins_three_pair"].played > 0 then
            return true
        end

        return false
    end,
    check_for_unlock = function(self, args)
        if G.GAME.last_hand_played and G.GAME.last_hand_played == "ins_three_pair" then
            return true
        end
    end,
    config = {
        hand_type = "ins_three_pair",
        softlock = true,
    },
    process_loc_text = function(self)
        G.localization.descriptions[self.set][self.key] = {
            text = G.localization.descriptions[self.set].c_mercury.text,
        }
    end,
    generate_ui = 0,
})
