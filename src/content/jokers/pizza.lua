SMODS.Shader({
    key = "pizza",
    path = "pizza.fs",
})

SMODS.Joker({
    key = "thepizza",
    atlas = "jokers",
    pos = { x = 3, y = 1 },
    rarity = "insolent",
    loc_txt = {
        ["en-us"] = {
            name = "The Pizza",
            text = {
                "Gives {X:blue,C:white}^#1#{} Mult for",
                "the next {C:attention}#2#{} rounds",
                "",
                "Shader: https://www.shadertoy.com/view/dtBBRK",
            },
        },
        ["nl"] = {
            name = "De Pizza",
            text = {
                "Geeft {X:blue,C:white}^#1#{} Mult voor de volgende ronden",
                "{C:attention}#2#{} rondes",
                "",
                "Shader: https://www.shadertoy.com/view/dtBBRK",
            },
        },
        ["es_ES"] = {
            name = "La Pizza",
            text = {
                "Da {X:blue,C:white}^#1#{} Mult para las próximas rondas",
                "{C:attention}#2#{} rondas",
                "",
                "Shader: https://www.shadertoy.com/view/dtBBRK",
            },
        },
        ["fr"] = {
            name = "La Pizza",
            text = {
                "Donne {X:blue,C:white}^#1#{} Mult pour les prochains tours",
                "{C:attention}#2#{} tours",
                "",
                "Shader : https://www.shadertoy.com/view/dtBBRK",
            },
        },
        ["de"] = {
            name = "Die Pizza",
            text = {
                "Gibt {X:blue,C:white}^#1#{} Mult für die nächsten Runden",
                "{C:attention}#2#{} Runden",
                "",
                "Shader: https://www.shadertoy.com/view/dtBBRK",
            },
        },
        ["pt_BR"] = {
            name = "A Pizza",
            text = {
                "Dará {X:blue,C:white}^#1#{} Mult para as próximas rodadas",
                "{C:attention}#2#{} rodadas",
                "",
                "Shader: https://www.shadertoy.com/view/dtBBRK",
            },
        },
        ["ru"] = {
            name = "Пицца",
            text = {
                "Дает {X:blue,C:white}^#1#{} Mult для следующих раундов",
                "{C:attention}#2#{} раундов",
                "",
                "Shader: https://www.shadertoy.com/view/dtBBRK",
            },
        },
        ["ja"] = {
            name = "ピザ",
            text = {
                "次のラウンドで {X:blue, C:white}^#1#{} Mult を与える",
                "{C:attention}#2#{} ラウンド",
                "",
                "Shader: https://www.shadertoy.com/view/dtBBRK",
            },
        },
        ["ko"] = {
            name = "피자",
            text = {
                "다음 라운드에서 {X:blue, C:white}^#1#{} Mult 를 드립니다",
                "{C:attention}#2#{} 라운드",
                "",
                "Shader: https://www.shadertoy.com/view/dtBBRK",
            },
        },
        ["zh_CN"] = {
            name = "比萨饼",
            text = {
                "为下一个轮次提供 {X:blue, C:white}^#1#{} Mult",
                "{C:attention}#2#{} 轮次",
                "",
                "Shader: https://www.shadertoy.com/view/dtBBRK",
            },
        },
        ["zh_TW"] = {
            name = "比薩餅",
            text = {
                "會給下一個回合 {X:blue, C:white}^#1#{} Mult",
                "{C:attention}#2#{} 輪次",
                "",
                "Shader: https://www.shadertoy.com/view/dtBBRK",
            },
        },
        ["it"] = {
            name = "La Pizza",
            text = {
                "Dà {X:blue, C:white}^#1#{} Mult per i prossimi turni",
                "{C:attention}#2#{} turni",
                "",
                "Shader: https://www.shadertoy.com/view/dtBBRK",
            },
        },
    },
    config = {
        extra = {
            emult = 3,
            remaining_rounds = 2,
        },
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["m_bearo_unoriginal_art"]

        return {
            vars = {
                card.ability.extra.emult,
                card.ability.extra.remaining_rounds,
            },
        }
    end,
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader("bearo_pizza", nil, card.ARGS.send_to_shader)
        end
    end,
    calculate = function(self, card, context)
        if
            context.end_of_round
            and not context.blueprint
            and not context.individual
            and not context.repetition
            and not context.retrigger_joker
        then
            local orig_remaining = card.ability.extra.remaining_rounds
            card.ability.extra.remaining_rounds = orig_remaining - 1

            if card.ability.extra.remaining_rounds > 0 then
                return {
                    message = "-1 Round",
                    colour = G.C.FILTER,
                }
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("tarot1")
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true

                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil

                                return true
                            end,
                        }))

                        return true
                    end,
                }))

                return {
                    mesage = "I Don't Cooka da Pizza",
                    colour = G.C.YELLOW,
                }
            end
        end

        if context.joker_main and context.cardarea == G.jokers and not context.individual then
            return {
                Emult_mod = card.ability.extra.emult,
                message = "Pizza, Pasta",
                card = card,
            }
        end
    end,
})
