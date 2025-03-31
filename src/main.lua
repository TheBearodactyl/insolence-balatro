BEARO = {}

BEARO.RARITIES = {}
BEARO.ENHANCEMENTS = {}
BEARO.JOKERS = {}
BEARO.DECKS = {}
BEARO.CONSUMABLES = {}
BEARO.TWEAKS = {}

SMODS.load_file("src/utils.lua")()
SMODS.load_file("src/atlas.lua")()

-- Rarities
SMODS.load_file("src/content/rarities/insolent.lua")()

-- Jokers
SMODS.load_file("src/content/jokers/heart_stop.lua")()
SMODS.load_file("src/content/jokers/the_sun.lua")()
SMODS.load_file("src/content/jokers/entropy.lua")()

-- Enhancements
SMODS.load_file("src/content/enhancements/woah.lua")()

-- Decks
SMODS.load_file("src/content/deck/woah_deck.lua")()



_RELEASE_MODE = false