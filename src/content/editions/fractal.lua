SMODS.Shader({
	key = "fractal",
	path = "fractal.fs",
})

SMODS.Edition({
	key = "fractal_ed",
	shader = "fractal",
	loc_txt = {
		["en-us"] = {
			name = "Fractal",
			label = "Fractal",
			text = {
				"Gives {X:planet,C:white,s:6,E:1}^#1#{} Mult",
				"when scoring a",
				"hand with a",
				"{C:attention}Lightshow{}, {C:attention}Kleinian{}",
				"{C:attention}Voronoi{}, and a {C:attention}Tiled{}",
				"card."
			},
		},
	},
	config = {
		extra = {
			emult = 3
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = BEARO.UTILS.unorig_cent()
		info_queue[#info_queue + 1] = G.P_CENTERS["e_bearo_lightshow_ed"]
		info_queue[#info_queue + 1] = G.P_CENTERS["e_bearo_kleinian_ed"]
		info_queue[#info_queue + 1] = G.P_CENTERS["e_bearo_voronoi_ed"]
		info_queue[#info_queue + 1] = G.P_CENTERS["e_bearo_tiled_ed"]

		return {
			vars = {
				self.config.extra.emult
			}
		}
	end,
	calculate = function(self, card, context)
		local has = {
			lightshow = false,
			kleinian = false,
			voronoi = false,
			tiled = false
		}

		if context.scoring_hand and #context.scoring_hand >= 4 then
			for k, v in pairs(context.scoring_hand) do
				if v.edition and v.edition.key == "e_bearo_lightshow_ed" then
					has.lightshow = true
				end

				if v.edition and v.edition.key == "e_bearo_kleinian_ed" then
					has.kleinian = true
				end

				if v.edition and v.edition.key == "e_bearo_voronoi_ed" then
					has.voronoi = true
				end

				if v.edition and v.edition.key == "e_bearo_tiled_ed" then
					has.tiled = true
				end
			end
		end

		if context.cardarea == G.play and context.main_scoring then
			if (has.lightshow and has.kleinian and has.voronoi and has.tiled) == true then
				return {
					Emult_mod = self.config.extra.emult,
					message = "f R a C t U r E d"
				}
			end
		end
	end,
})
