local lovely = require("lovely")

for _, ext in ipairs({ "dll", "so" }) do
	package.cpath = package.cpath .. ";" .. lovely.mod_dir .. "/Insolence/lib/?." .. ext
end

--- @class InsolenceLib
--- @field between fun(num: number, min: number, max: number): boolean
--- @field largest_val fun(tbl: table): any?
--- @field average_table_amt fun(tbl: table): number
--- @field reverse_table fun(tbl: table): table
--- @field capitalize fun(word: string?): string | nil
--- @field every_day_im_shufflin fun(tbl: table): table
--- @field rand_mem_addr fun(): string
--- @field placeholder_sprite fun(): table
--- @field within fun(x: number, y: number): boolean
--- @field random_str fun(len: number, char_set?: string): string
--- @field hex fun(hex: string): table
--- @field rand_hex_code fun(): table
--- @field rand_int fun(min: integer, max: integer): integer
--- @field rand_num fun(min: number, max: number): number
--- @field random_table_of_strs fun(str_len: number, tbl_len: number): table
--- @field rand_table_of_hex_codes fun(len: number): table
--- @field mod_vals fun(input: number | table, modifier: number): number | table
--- @field wave_number fun(num: number): number
--- @field clamp fun(num: number, min: number, max: number): number
--- @field chance fun(percent_chance: number): boolean
--- @field exponentiate fun(base: number, power: number): number
--- @field boobs_sprite fun(mod_cfg: table): table
--- @field include_content fun(name: string, ty: string): nil
--- @field include fun(path: string): nil
--- @field word_to_color fun(word: string): string
--- @field random_joker fun(seed?: string, excluded_flags?: table, banned_card?: string, pool?: table, no_undiscovered?: boolean): table
--- @field is_rigged_cryptid fun(card: table): boolean
--- @field mod_cond fun(mod_id: string, if_exists: any, otherwise: any): any
--- @field count_num_of_joker fun(prefix: string, key: string): integer
--- @field register_items fun(items: string[], path: string)
--- @field create_gradient fun(key: string, colors: string[]): SMODS.Gradient
libinsolence = require("libinsolence")

for k, _ in pairs(insolence.content) do
	libinsolence.register_items(insolence.content[k], "src/content/" .. k)
end

local function calculate_scalefactor(text)
	local size = 0.9
	local font = G.LANG.font
	local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
	local calced_text_width = 0
	for _, c in utf8.chars(text) do
		--- @diagnostic disable-next-line: undefined-field
		local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE
			--- @diagnostic disable-next-line: undefined-field
			+ 2.7 * 1 * G.TILESCALE * font.FONTSCALE
		calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
	end
	local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
	return scale_fac
end

---@diagnostic disable: duplicate-set-field
local smcmb = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
	smcmb(obj, badges)

	if obj and obj.misc_badge then
		local scale_fac = {}
		local scale_fac_len = 1
		if obj.misc_badge and obj.misc_badge.text then
			for i = 1, #obj.misc_badge.text do
				local calced_scale = calculate_scalefactor(obj.misc_badge.text[i])
				scale_fac[i] = calced_scale
				scale_fac_len = math.min(scale_fac_len, calced_scale)
			end
		end
		local ct = {}
		for i = 1, #obj.misc_badge.text do
			ct[i] = {
				string = obj.misc_badge.text[i],
			}
		end
		badges[#badges + 1] = {
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = {
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						colour = obj.misc_badge and obj.misc_badge.colour or G.C.RED,
						r = 0.1,
						minw = 2 / scale_fac_len,
						minh = 0.36,
						emboss = 0.05,
						padding = 0.03 * 0.9,
					},
					nodes = {
						{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
						{
							n = G.UIT.O,
							config = {
								object = DynaText({
									string = ct or "ERROR",
									colours = { obj.misc_badge and obj.misc_badge.text_colour or G.C.WHITE },
									silent = true,
									float = true,
									shadow = true,
									offset_y = -0.03,
									spacing = 1,
									scale = 0.33 * 0.9,
								}),
							},
						},
						{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
					},
				},
			},
		}
	end
	if obj then
		for k, v in pairs(insolence.modifier_badges) do
			if obj[k] and obj[k] ~= nil then
				local scale_fac = {}
				local scale_fac_len = 1
				if v.text then
					for i = 1, #v.text do
						local calced_scale = calculate_scalefactor(v.text[i])
						scale_fac[i] = calced_scale
						scale_fac_len = math.min(scale_fac_len, calced_scale)
					end
				end
				local ct = {}
				for i = 1, #v.text do
					ct[i] = {
						string = v.text[i],
					}
				end
				badges[#badges + 1] = {
					n = G.UIT.R,
					config = { align = "cm" },
					nodes = {
						{
							n = G.UIT.R,
							config = {
								align = "cm",
								colour = v and v.col or G.C.RED,
								r = 0.1,
								minw = 2 / scale_fac_len,
								minh = 0.36,
								emboss = 0.05,
								padding = 0.03 * 0.9,
							},
							nodes = {
								{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = ct or "ERROR",
											colours = { v and v.tcol or G.C.WHITE },
											silent = true,
											float = true,
											shadow = true,
											offset_y = -0.03,
											spacing = 1,
											scale = 0.33 * 0.9,
										}),
									},
								},
								{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
							},
						},
					},
				}
			end
		end
	end
end

G.C.PINK = HEX("ff00bb")

local orig_gmm = Game.main_menu
function Game.main_menu(change_context)
	local ret = orig_gmm(change_context)

	--insolence.update_check()

	local newcard = Card(
		G.title_top.T.x,
		G.title_top.T.y,
		G.CARD_W,
		G.CARD_H,
		G.P_CARDS.empty,
		G.P_CENTERS["j_ins_natsuri"],
		{ bypass_discovery_center = true }
	)

	G.title_top.T.w = G.title_top.T.w * 1.7675
	G.title_top.T.x = G.title_top.T.x - 0.8
	G.title_top:emplace(newcard)

	newcard.T.w = newcard.T.w * 1.1 * 1.2
	newcard.T.h = newcard.T.h * 1.1 * 1.2
	newcard.no_ui = true
	newcard.states.visible = false

	G.SPLASH_BACK:define_draw_steps({
		{
			shader = "splash",
			send = {
				{ name = "time", ref_table = G.TIMERS, ref_value = "REAL_SHADER" },
				{ name = "vort_speed", val = 0.4 },
				{ name = "colour_1", ref_table = G.C, ref_value = "PURPLE" },
				{ name = "colour_2", ref_table = G.C, ref_value = "PINK" },
			},
		},
	})

	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0,
		blockable = false,
		blocking = false,
		func = function()
			if change_context == "splash" then
				newcard.states.visible = true
				newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, true, 2.5)
			else
				newcard.states.visible = true
				newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 1.2)
			end

			return true
		end,
	}))

	return ret
end

G.FUNCS.ins_cycle_options = function(args)
	args = args or {}

	if args.cycle_config and args.cycle_config.ref_table and args.cycle_config.ref_value then
		args.cycle_config.ref_table[args.cycle_config.ref_value] = args.to_key
	end
end

insolence.mod.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = {
			align = "cm",
			minh = G.ROOM.T.h * 0.6,
			minw = G.ROOM.T.w * 0.6,
			padding = 0.5,
			r = 0.1,
			colour = G.C.GREY,
			outline = 0.7,
			outline_colour = G.C.PINK,
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
							colour = libinsolence.mod_cond("Cryptid", G.C.CRY_BLOSSOM, G.C.CHIPS),
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
						ref_table = insolence.mod.config,
						ref_value = "adult_mode",
					}),
					create_toggle({
						label = "Enable Woah SFX",
						ref_table = insolence.mod.config,
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
							colour = libinsolence.mod_cond("Cryptid", G.C.CRY_BLOSSOM, G.C.CHIPS),
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
						info = localize("insolence_music_description"),
						options = localize("insolence_music_options"),
						current_option = insolence.mod.config.mugiwara_music,
						colour = G.C.PINK,
						text_scale = 0.5,
						ref_table = insolence.mod.config,
						ref_value = "mugiwara_music",
						opt_callback = "ins_cycle_options",
					}),
					create_option_cycle({
						label = "Sam Laskey Music",
						w = 4.5,
						info = localize("insolence_laskey_music_description"),
						options = localize("insolence_laskey_music_options"),
						current_option = insolence.mod.config.samlaskey_music,
						colour = G.C.PINK,
						text_scale = 0.5,
						ref_table = insolence.mod.config,
						ref_value = "samlaskey_music",
						opt_callback = "ins_cycle_options",
					}),
				},
			},
		},
	}
end

insolence.mod.optional_features = {
	retrigger_joker = true,
}
