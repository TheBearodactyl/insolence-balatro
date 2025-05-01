local orig_cp = G.FUNCS.can_play
SMODS.Joker {
    key = "filthy",
    atlas = "timetostop",
    pos = { x = 0, y = 0 },
    rarity = "insolent",
    blueprint_compat = false,
    cost = 50,
    loc_txt = {
        ["en-us"] = {
            name = "It's Time to Stop",
            text = {
                "Lets you decide when the {C:attention}round{} ends"
            }
        }
    },
    update = function (self, card, dt)
        if BEARO.UTILS.count_num_of_joker("bearo", "filthy") >= 1 then
            BEARO.has_stop = true
        else
            BEARO.has_stop = false
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.FUNCS.can_play = function(e)
            if G.GAME.current_round.hands_left <= 0 then
                e.config.colour = G.C.UI.BACKGROUND_INACTIVE
                e.config.button = nil
            else
                orig_cp(e)
            end
        end
    end,
    remove_from_deck = function (self, card, from_debuff)
        BEARO.has_stop = false
    end
}


-- Based on the NotJustYet mod!
G.FUNCS.bearo_can_end_round = function(e)
    if not to_big then
        function to_big(x) return x end
    end

    if to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) then
        e.config.colour = G.C[G.bearo_colour]
        e.config.button = "bearo_attempt_end_round"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.bearo_attempt_end_round = function(e)
    if G.STATE ~= G.STATES.NEW_ROUND then
        stop_use()
        G.STATE = G.STATES.NEW_ROUND
        end_round()
    end
end

G.FUNCS.bearo_endround = true
