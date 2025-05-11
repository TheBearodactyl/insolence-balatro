SMODS.Shader {
    key = "fractal",
    path = "fractal.fs"
}

SMODS.Edition {
    key = "fractal_ed",
    shader = "fractal",
    unoriginal_shader = true,
    loc_txt = {
        ["en-us"] = {
            name = "Fractal",
            label = "Fractal",
            text = {
                "TODO"
            }
        }
    },
    config = {
        extra = {
        }
    },
    loc_vars = function(self, info_queue, card)
    end,
    calculate = function(self, card, context)
    end
}
