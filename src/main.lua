--- @class Utils
--- @field load fun(path: string)
local util = require("bearo.utils")

insolence = {
	content = {
		achievements = {
			"boob_achievements",
		},
		enhancements = {
			"unoriginal",
			"woah",
			"bubbly",
		},
		blinds = {
			"chris_rock",
			"will_smith",
		},
		jokers = {
			"boobs",
			"brook",
			"eternalinator",
			"fingertips",
			"franky",
			"garry",
			"italian",
			"metroman",
			"mugiwara",
			"nami",
			"natsuri",
			"nice_day_out",
			"pizza",
			"printer_ink",
			"probably",
			"rotoscoped",
			"stained_glass",
			"stopped_heart",
			"the_watcher",
			"wildin",
			"woah_joker",
			"future_funk",
			"speedpaint",
			"nineeleven"
		},
		rarities = {
			"insolent",
			"strawhat",
		},
		editions = {
			"ace",
			"aurora",
			"bisexual",
			"bocchi",
			"bugged",
			"cellular",
			"edgy",
			"equalize",
			"fractal",
			"gay",
			"kleinian",
			"lesbian",
			"lightshow",
			"pinku",
			"synth",
			"tiled",
			"trans",
			"universe",
			"vaporwave",
			"voronoi",
			"wavy",
		},
		consumables = {
			"borealis",
			"nullptr",
			"soup",
			"toaster_bath",
			"supernova",
			"flower",
			"tiler",
			"wulz",
		},
		hands = {
			"aaaaaa",
			"three_pair",
		},
	},
	mod = SMODS.current_mod,
	modifier_badges = {
		gear1 = {
			text = {
				"Gear 1",
				"Rubber Man",
			},
			col = HEX("8f00ff"),
			tcol = G.C.EDITION,
		},
		gear2 = {
			text = {
				"Gear 2",
				"Rubber Jet",
			},
			col = G.C.ORANGE,
			tcol = G.C.EDITION,
		},
		gear3 = {
			text = {
				"Gear 3",
				"Rubber Giant",
			},
			col = G.C.GREEN,
			tcol = G.C.EDITION,
		},
		gear4 = {
			text = {
				"Gear 4",
				"Bounce Man",
			},
			col = G.C.BLACK,
			tcol = G.C.EDITION,
		},
		gear5 = {
			text = {
				"Gear 5",
				"Rubber Dawn",
			},
			col = G.C.WHITE,
			tcol = G.C.BLUE,
		},
		galaxy_card = {
			text = {
				"A Galaxy",
				"in a card",
			},
			tcol = G.C.BLACK,
			col = G.C.WHITE,
		},
		unoriginal_shader = {
			text = {
				"NON-ORIGINAL SHADER",
				"THIS SHADER IS NOT",
				"WRITTEN BY ME",
			},
			tcol = G.C.WHITE,
			col = G.C.RED,
		},
		natsuri = {
			text = {
				"Girls Kissing",
			},
			tcol = G.C.WHITE,
			col = G.C.PURPLE,
		},
	},
}

-- Register atlases
util.load("src/atlas.lua")

-- Load the mod
util.load("src/load.lua")