---@diagnostic disable: duplicate-set-field

BEARO = {}
BEARO.bugged_msgs = {}
BEARO.galaxy_count = 0
BEARO.MOD = SMODS.current_mod
BEARO.MOD.optional_features = {
    retrigger_joker = true
}

SMODS.load_file("src/utils.lua")()
SMODS.load_file("src/atlas.lua")()

-- Rarities
SMODS.load_file("src/content/rarities/insolent.lua")()
SMODS.load_file("src/content/rarities/fleeting.lua")()
SMODS.load_file("src/content/rarities/defiant.lua")()
SMODS.load_file("src/content/rarities/straw_hat.lua")()

-- Jokers
SMODS.load_file("src/content/jokers/woah_joker.lua")()
SMODS.load_file("src/content/jokers/fingertips.lua")()
SMODS.load_file("src/content/jokers/heart_stop.lua")()
SMODS.load_file("src/content/jokers/boobs.lua")()
SMODS.load_file("src/content/jokers/the_sun.lua")()
SMODS.load_file("src/content/jokers/probably.lua")()
SMODS.load_file("src/content/jokers/eternalinator.lua")()
SMODS.load_file("src/content/jokers/entropy.lua")()
SMODS.load_file("src/content/jokers/fear.lua")()
SMODS.load_file("src/content/jokers/mugiwara.lua")()

-- Enhancements
SMODS.load_file("src/content/enhancements/woah.lua")()

-- Consumables
SMODS.load_file("src/content/consumables/electrified_bath.lua")()
SMODS.load_file("src/content/consumables/primordial_soup.lua")()
SMODS.load_file("src/content/consumables/wulz.lua")()
SMODS.load_file("src/content/consumables/the_flower.lua")()
SMODS.load_file("src/content/consumables/supernova.lua")()

-- Editions
-- SMODS.load_file("src/content/editions/bocchi.lua")() -- shader is bugged
SMODS.load_file("src/content/editions/lesbian.lua")()
SMODS.load_file("src/content/editions/gay.lua")()
SMODS.load_file("src/content/editions/bisexual.lua")()
SMODS.load_file("src/content/editions/trans.lua")()
SMODS.load_file("src/content/editions/ace.lua")()
SMODS.load_file("src/content/editions/cellular.lua")()
SMODS.load_file("src/content/editions/edgy.lua")()
SMODS.load_file("src/content/editions/vaporwave.lua")()
SMODS.load_file("src/content/editions/voronoi.lua")()
SMODS.load_file("src/content/editions/aurora.lua")()
SMODS.load_file("src/content/editions/universe.lua")()
SMODS.load_file("src/content/editions/pinku.lua")()
SMODS.load_file("src/content/editions/digitalink.lua")()
SMODS.load_file("src/content/editions/bugged.lua")()

-- Decks
SMODS.load_file("src/content/deck/woah_deck.lua")()

-- Tweaks
SMODS.load_file("src/modifier_badges.lua")()
SMODS.load_file("src/content/tweaks/big_hand_formatting.lua")()
SMODS.load_file("src/content/tweaks/more_mod_badges.lua")()

-- Achievements
SMODS.load_file("src/content/achievement/boob_achievements.lua")()

G.FUNCS.bearo_cycle_options = function(args)
    args = args or {}

    if args.cycle_config and args.cycle_config.ref_table and args.cycle_config.ref_value then
        args.cycle_config.ref_table[args.cycle_config.ref_value] = args.to_key
    end
end

SMODS.current_mod.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = {
            align = "cl",
            minh = G.ROOM.T.h * 0.25,
            padding = 0.0,
            r = 0.1,
            colour = G.C.GREY
        },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    minw = G.ROOM.T.w * 0.25,
                    padding = 0.05,
                },
                nodes = {
                    create_toggle({
                        label = "18+ mode (contains booba)",
                        ref_table = BEARO.MOD.config,
                        ref_value = "adult_mode"
                    }),
                    create_option_cycle({
                        label = "Mugiwara Music",
                        w = 4.5,
                        info = localize("bearo_music_description"),
                        options = localize("bearo_music_options"),
                        current_option = BEARO.MOD.config.mugiwara_music,
                        colour = HEX("ff00bb"),
                        text_scale = 0.5,
                        ref_table = BEARO.MOD.config,
                        ref_value = "mugiwara_music",
                        opt_callback = "bearo_cycle_options"
                    }),
                }
            }
        }
    }
end
