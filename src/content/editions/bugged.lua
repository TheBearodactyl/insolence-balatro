SMODS.Shader {
    key = "bugged",
    path = "bugged.fs"
}

local bugged_gradient = BEARO.UTILS.create_gradient("bugged_grad", BEARO.UTILS.rand_table_of_hex_codes(5))

SMODS.Edition {
    key = "bugged_ed",
    shader = "bugged",
    config = {
        extra = {
            min_mult = 5,
            max_mult = 20,
        }
    },
    badge_colour = bugged_gradient,
    loc_vars = function(self, info_queue, card)
        BEARO.bugged_msgs = {
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.RED },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.RED },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.BLACK },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.CHIPS },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.GOLD },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.GREEN },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.BLACK },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.CHIPS },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.GOLD },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.GREEN },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.RED },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.RED },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.BLACK },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.CHIPS },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.GOLD },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.GREEN },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.BLACK },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.CHIPS },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.GOLD },
            { string = BEARO.UTILS.random_str(BEARO.UTILS.rand_int(10, 15)), colour = G.C.GREEN },
        }

        return {
            main_start = {
                {
                    n = G.UIT.O,
                    config = {
                        object = DynaText({
                            string = BEARO.bugged_msgs,
                            font = G.FONTS[BEARO.UTILS.rand_int(1, 9)],
                            colours = { G.C.DARK_EDITION },
                            pop_in_rate = 9999999,
                            silent = true,
                            random_element = true,
                            pop_delay = 0.15,
                            scale = math.floor(BEARO.UTILS.rand_int(1, 10)),
                            min_cycle_time = 0,
                        }),
                    },
                },
            }
        }
    end,
    loc_txt = {
        ["en-us"] = {
            name = "Bugged",
            label = BEARO.UTILS.random_str(12),
            text = { "" }
        }
    },
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            local bugged_mult = math.sin(BEARO.UTILS.rand_num(self.config.extra.min_mult, self.config.extra.max_mult))

            return {
                mult = (math.pi + math.pi) * bugged_mult
            }
        end
    end,
}
