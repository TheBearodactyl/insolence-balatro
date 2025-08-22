--- @class Utils
--- @field load fun(path: string)
local util = require("bearo.utils")

insolence = {
	content = {
		achievements = {
			["boob_achievements"] ={
				enabled = true
			},
		},
		enhancements = {
			["unoriginal"] ={
				enabled = true
			},
			["woah"] ={
				enabled = true
			},
			["bubbly"] ={
				enabled = true
			},
		},
		blinds = {
			["chris_rock"] = {
				enabled = true
			},
			["will_smith"] = {
				enabled = true
			},
		},
		jokers = {
			["boobs"] = {
				enabled = true
			},
			["brook"] = {
				enabled = true
			},
			["eternalinator"] = {
				enabled = true
			},
			["fingertips"] = {
				enabled = true
			},
			["franky"] = {
				enabled = true
			},
			["garry"] = {
				enabled = true
			},
			["italian"] = {
				enabled = true
			},
			["metroman"] = {
				enabled = true
			},
			["mugiwara"] = {
				enabled = true
			},
			["nami"] = {
				enabled = true
			},
			["natsuri"] = {
				enabled = true
			},
			["nice_day_out"] = {
				enabled = true
			},
			["pizza"] = {
				enabled = true
			},
			["printer_ink"] = {
				enabled = true
			},
			["probably"] = {
				enabled = true
			},
			["rotoscoped"] = {
				enabled = true
			},
			["stained_glass"] = {
				enabled = true
			},
			["stopped_heart"] = {
				enabled = true
			},
			["the_watcher"] = {
				enabled = true
			},
			["wildin"] = {
				enabled = true
			},
			["woah_joker"] = {
				enabled = true
			},
			["future_funk"] = {
				enabled = true
			},
			["speedpaint"] = {
				enabled = true
			},
			["nineeleven"] = {
				enabled = true
			},
			["monika"] = {
				enabled = true
			},
		},
		rarities = {
			["insolent"] = {
				enabled = true
			},
			["strawhat"] = {
				enabled = true
			},
		},
		editions = {
			["ace"] = {
				enabled = true
			},
			
			["aurora"] = {
				enabled = true
			},
			
			["bisexual"] = {
				enabled = true
			},
			
			["bocchi"] = {
				enabled = true
			},
			
			["bugged"] = {
				enabled = true
			},
			
			["cellular"] = {
				enabled = true
			},
			
			["edgy"] = {
				enabled = true
			},
			
			["equalize"] = {
				enabled = true
			},
			
			["fractal"] = {
				enabled = true
			},
			
			["gay"] = {
				enabled = true
			},
			
			["kleinian"] = {
				enabled = true
			},
			
			["lesbian"] = {
				enabled = true
			},
			
			["lightshow"] = {
				enabled = true
			},
			
			["pinku"] = {
				enabled = true
			},
			
			["synth"] = {
				enabled = true
			},
			
			["tiled"] = {
				enabled = true
			},
			
			["trans"] = {
				enabled = true
			},
			
			["universe"] = {
				enabled = true
			},
			
			["vaporwave"] = {
				enabled = true
			},
			
			["voronoi"] = {
				enabled = true
			},
			
			["wavy"] = {
				enabled = true
			},
			
		},
		consumables = {
			["borealis"] = {
				enabled = true
			},
			["nullptr"] = {
				enabled = true
			},
			["soup"] = {
				enabled = true
			},
			["toaster_bath"] = {
				enabled = true
			},
			["supernova"] = {
				enabled = true
			},
			["flower"] = {
				enabled = true
			},
			["tiler"] = {
				enabled = true
			},
			["wulz"] = {
				enabled = true
			},
		},
		hands = {
			["aaaaaa"] = {
				enabled = true
			},
			["three_pair"] = {
				enabled = true
			},
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
