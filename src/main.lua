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
            "lesbian"
        }
    },
    mod = SMODS.current_mod
}

util.load("src/load.lua")
util.load("src/atlas.lua")