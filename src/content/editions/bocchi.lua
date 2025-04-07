SMODS.Shader {
    key = "bocchi",
    path = "bocchi.fs"
}

SMODS.Edition {
    key = "bocchi_ed",
    shader = "bocchi",
    loc_txt = {
        ["en-us"] = {
            label = "ROCKIN'"
        }
    },
    in_shop = true,
    disable_base_shader = true,
    config = {
        x_mult = 2,
        mult = 10,
    },
}
