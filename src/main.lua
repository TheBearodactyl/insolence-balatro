---@diagnostic disable: duplicate-set-field

BEARO = {}
BEARO.bugged_msgs = {}
BEARO.galaxy_count = 0
BEARO.MOD = SMODS.current_mod
BEARO.MOD.optional_features = {
	retrigger_joker = true,
}

SMODS.load_file("src/utils.lua")()
SMODS.load_file("src/atlas.lua")()

local incl = BEARO.UTILS.include_content

-- Rarities
incl("insolent", "rarities")
incl("fleeting", "rarities")
incl("defiant", "rarities")
incl("straw_hat", "rarities")

-- Jokers
incl("woah_joker", "jokers")    -- Common
incl("eternalinator", "jokers") -- Uncommon
incl("boobs", "jokers")         -- Uncommon
incl("fingertips", "jokers")    -- Rare
incl("garry", "jokers")         -- Rare
incl("heart_stop", "jokers")    -- Rare
incl("the_sun", "jokers")       -- Legendary
incl("rotoscoped", "jokers")    -- Insolent
incl("timetostop", "jokers")    -- Insolent
incl("metroman", "jokers")      -- Insolent
incl("probably", "jokers")      -- Insolent
incl("entropy", "jokers")       -- Insolent
incl("mugiwara", "jokers")      -- Straw Hat
incl("nami", "jokers")          -- Straw Hat
incl("franky", "jokers")        -- Straw Hat
incl("brook", "jokers")         -- Straw Hat

-- Enhancements
incl("woah", "enhancements")
incl("legendary", "enhancements")

-- Consumables
incl("electrified_bath", "consumables")
incl("primordial_soup", "consumables")
incl("wulz", "consumables")
incl("the_flower", "consumables")
incl("supernova", "consumables")

-- Editions
-- include("bocchi", "editions") -- shader is bugged
incl("lesbian", "editions")
incl("gay", "editions")
incl("bisexual", "editions")
incl("trans", "editions")
incl("ace", "editions")
incl("cellular", "editions")
incl("edgy", "editions")
incl("vaporwave", "editions")
incl("voronoi", "editions")
incl("aurora", "editions")
incl("universe", "editions")
incl("pinku", "editions")
incl("digitalink", "editions")
incl("bugged", "editions")

-- Decks
incl("woah_deck", "deck")
incl("legendary_deck", "deck")
incl("edition_decks", "deck")

-- Tweaks
BEARO.UTILS.include("src/modifier_badges.lua")
incl("big_hand_formatting", "tweaks")
incl("more_mod_badges", "tweaks")
incl("custom_game_update", "tweaks")
incl("more_contexts", "tweaks")

-- Achievements
incl("boob_achievements", "achievements")

if SMODS.Mods["JokerDisplay"].can_load then
	BEARO.UTILS.include("src/joker_disp.lua")
end

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
			colour = G.C.GREY,
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
						ref_value = "adult_mode",
					}),
					create_toggle({
						label = "Enable Woah SFX",
						ref_table = BEARO.MOD.config,
						ref_value = "woah_sfx"
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
						opt_callback = "bearo_cycle_options",
					}),
				},
			},
		},
	}
end
