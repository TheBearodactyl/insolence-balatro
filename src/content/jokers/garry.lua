local gmod_msgs = {
    { string = "crowbar", colour = G.C.BLACK },
    { string = "halflife", colour = G.C.GOLD },
    { string = "nextbot", colour = G.C.PURPLE }
}

SMODS.Joker {
    key = "garry",
    atlas = "gmod",
    pos = { x = 0, y = 0 },
    cost = 50,
    rarity = 3,
    loc_txt = {
        ["en-us"] = {
            name = "GMOD",
            text = {
                "Create a {C:chips}Blueprint{} after",
                "5 {C:attention}rounds{} {C:inactive{}(#1#){}",
                " ",
                "{C:red}Self Destructs{}"
            }
        }
    },
    config = {
        extra = {
            rounds_left = 5
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.rounds_left
            },
            main_start = { BEARO.UTILS.cycling_text(gmod_msgs, true, 0.15, 0.5) }
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
            card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1

            if card.ability.extra.rounds_left == 0 then
                G.E_MANAGER:add_event(Event {
                    func = function()
                        local bp = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_blueprint")
                        bp:add_to_deck()
                        G.jokers:emplace(bp)

                        return true
                    end
                })

                card:start_dissolve()

                return {
                    card = card,
                    message = "Nextbot"
                }
            end
        end
    end
}
