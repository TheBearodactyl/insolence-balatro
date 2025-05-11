---@diagnostic disable: duplicate-set-field

BEARO = {}
BEARO.has_stop = false
G.bearo_colour = "GREEN"
--- @type (table | Mod)?
BEARO.MOD = SMODS.current_mod
BEARO.MOD.optional_features = {
	retrigger_joker = true,
}

SMODS.load_file("src/lib/utils.lua")()
SMODS.load_file("src/lib/atlas.lua")()
SMODS.load_file("src/lib/modifiers.lua")()
if (SMODS.Mods["DebugPlus"] or {}).can_load then
	SMODS.load_file("src/lib/debug_plus.lua")()
end

--- @type function
local incl = BEARO.UTILS.include_content

-- Rarities
incl("insolent", "rarities")
--incl("defiant", "rarities")
incl("straw_hat", "rarities")

-- Jokers
incl("woah_joker", "jokers") -- Common
incl("eternalinator", "jokers") -- Uncommon
incl("boobs", "jokers") -- Uncommon
incl("probablynot", "jokers") -- Uncommon
incl("fingertips", "jokers") -- Rare
incl("garry", "jokers") -- Rare
incl("heart_stop", "jokers") -- Rare
incl("the_sun", "jokers") -- Legendary
incl("rotoscoped", "jokers") -- Insolent
incl("timetostop", "jokers") -- Insolent
incl("samlaskey", "jokers") -- Insolent
incl("metroman", "jokers") -- Insolent
incl("probably", "jokers") -- Insolent
incl("mugiwara", "jokers") -- Straw Hat
incl("nami", "jokers") -- Straw Hat
incl("franky", "jokers") -- Straw Hat
incl("brook", "jokers") -- Straw Hat

-- Enhancements
incl("woah", "enhancements")
incl("legendary", "enhancements")

-- Consumables
incl("electrified_bath", "consumables")
incl("primordial_soup", "consumables")
incl("wulz", "consumables")
incl("the_flower", "consumables")
incl("supernova", "consumables")
incl("tiler", "consumables")

-- Editions
incl("lesbian", "editions")
incl("gay", "editions")
incl("bisexual", "editions")
incl("trans", "editions")
incl("ace", "editions")
incl("bocchi", "editions")
incl("cellular", "editions")
incl("edgy", "editions")
incl("vaporwave", "editions")
incl("voronoi", "editions")
incl("aurora", "editions")
incl("universe", "editions")
incl("pinku", "editions")
incl("digitalink", "editions")
incl("bugged", "editions")
incl("wavy", "editions")
incl("bubbly", "editions")
incl("equalize", "editions")
incl("lightshow", "editions")
incl("tiled", "editions")
incl("synth", "editions")
incl("kleinian", "editions")
incl("fractal", "editions")

-- Decks
incl("woah_deck", "deck")
incl("legendary_deck", "deck")
incl("edition_decks", "deck")
incl("tempered_glass_deck", "deck")
incl("cloud_deck", "deck")

-- Tweaks
BEARO.UTILS.include("src/lib/modifier_badges.lua")
incl("big_hand_formatting", "tweaks")
incl("more_mod_badges", "tweaks")
incl("custom_game_update", "tweaks")
incl("more_contexts", "tweaks")

-- Poker Hands
incl("three_pair", "poker_hands")

-- Achievements
incl("boob_achievements", "achievements")

if (SMODS.Mods["JokerDisplay"] or {}).can_load then
	BEARO.UTILS.include("src/lib/joker_disp.lua")
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
			--- @type string
			align = "cm",
			--- @type number
			minh = G.ROOM.T.h * 0.6,
			--- @type number
			minw = G.ROOM.T.w * 0.6,
			--- @type number
			padding = 0.5,
			--- @type number
			r = 0.1,
			--- @type table
			colour = G.C.GREY,
			--- @type number
			outline = 0.7,
			--- @type table
			outline_colour = G.C.YELLOW,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					align = "tm",
					minw = G.ROOM.T.w * 0.3,
					padding = 0.025,
					r = 0.25,
				},
				nodes = {
					{
						n = G.UIT.R,
						config = {
							align = "tm",
							minw = G.ROOM.T.w * 0.15,
							padding = 0.25,
							colour = BEARO.UTILS.mod_cond("Cryptid", G.C.CRY_BLOSSOM, G.C.CHIPS),
							no_fill = false,
							r = 0.25,
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "Settings",
									scale = 0.75,
								},
							},
						},
					},
					create_toggle({
						label = "18+ mode (contains booba)",
						ref_table = BEARO.MOD.config,
						ref_value = "adult_mode",
					}),
					create_toggle({
						label = "Enable Woah SFX",
						ref_table = BEARO.MOD.config,
						ref_value = "woah_sfx",
					}),
				},
			},

			{
				n = G.UIT.C,
				config = {
					align = "bm",
					minw = G.ROOM.T.w * 0.3,
					padding = 0.025,
					r = 0.25,
				},
				nodes = {
					{
						n = G.UIT.R,
						config = {
							align = "tm",
							minw = G.ROOM.T.w * 0.15,
							padding = 0.25,
							colour = BEARO.UTILS.mod_cond("Cryptid", G.C.CRY_BLOSSOM, G.C.CHIPS),
							no_fill = false,
							r = 0.25,
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "Music Options",
									scale = 0.75,
								},
							},
						},
					},
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
					create_option_cycle({
						label = "Sam Laskey Music",
						w = 4.5,
						info = localize("bearo_laskey_music_description"),
						options = localize("bearo_laskey_music_options"),
						current_option = BEARO.MOD.config.samlaskey_music,
						colour = HEX("ff00bb"),
						text_scale = 0.5,
						ref_table = BEARO.MOD.config,
						ref_value = "samlaskey_music",
						opt_callback = "bearo_cycle_options",
					}),
				},
			},
		},
	}
end
