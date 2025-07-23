SMODS.Joker {
    key = "monika",
    atlas = "jokers",
    pos = {
        x = 6,
        y = 1
    },
    rarity = "insolent",
    loc_txt = {
        ["en-us"] = {
            name = "Just Monika.",
            text = {
                "Just Monika :)",
                "{C:inactive}(Currently {X:planet,C:white,s:1.7}^#1#{C:inactive} Mult)"
            }
        }
    },
    config = {
        extra = {
            emult = 1,
            emult_mod = 0.5
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.extra.emult
            }
        }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event {
            func = function()
                if G.jokers then
                    G.jokers.config.card_limit = 1
                end

                return true
            end
        })

        local file = NFS.newFile("monika.chr")
        file:open("w")
        file:write("just monika :)")
        if file:close() then
            print("made monika")
        else
            error("failed to create monika :(")
        end

        card:set_eternal(true)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event {
            delay = 3,
            func = function()
                return true
            end
        })

        G.GAME.blind.config.blind = "Monika"
        if G.STAGE == G.STAGES.RUN then
            G.STATE = G.STATES.GAME_OVER
            G.STATE_COMPLETE = false
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.blueprint and context.cardarea == G.jokers then
            self.config.extra.emult = self.config.extra.emult + self.config.extra.emult_mod

            return {
                message = localize("k_upgrade_ex")
            }
        end

        if not NFS.getInfo("monika.chr") and not context.repetition then
            G.E_MANAGER:add_event(Event {
                func = function()
                    play_sound("tarot1")
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true

                    G.E_MANAGER:add_event(Event {
                        trigger = "after",
                        delay = 0.3,
                        blockable = false,
                        func = function()
                            G.jokers:remove_card(card)
                            card:remove()
                            card = nil

                            return true
                        end
                    })

                    return true
                end
            })

            return {
                message = "How could you...",
                colour = G.C.RED
            }
        else
            if context.joker_main and context.cardarea == G.jokers then
                return {
                    Emult_mod = self.config.extra.emult,
                    message = "Just Monika :3"
                }
            end
        end
    end
}
