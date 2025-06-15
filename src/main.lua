--- @class Utils
--- @field load fun(path: string)
local util = require("bearo.utils")

insolence = {
    content = {
        jokers = {
            "boobs",
            "stained_glass",
            "natsuri",
            "fingertips"
        },
        rarities = {
            "insolent"
        },
        editions = {
            "ace",
            "aurora",
            "bisexual",
            "bugged",
            "cellular",
            "edgy",
            "gay",
            "lesbian",
            "pinku",
            "tiled",
            "universe"
        },
        consumables = {
            "borealis",
            "nullptr",
            "soup"
        }
    },
    mod = SMODS.current_mod
}

util.load("src/load.lua")
util.load("src/atlas.lua")