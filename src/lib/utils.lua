local utf8 = require("utf8")

--- @diagnostic disable: duplicate-set-field

BEARO.UTILS = {}
BEARO.UTILS.H = {}

--- @alias include_type
--- | "achievements" # An Achievement
--- | "consumables"  # A Consumable
--- | "deck"         # A Deck
--- | "editions"     # An Edition
--- | "enhancements" # An Enhancement
--- | "jokers"       # A Joker
--- | "rarities"     # A Rarity
--- | "tweaks"       # A Tweak
--- | "stakes"       # A Stake

--- @param name string
--- @param type include_type
BEARO.UTILS.include_content = function(name, type)
	SMODS.load_file("src/content/" .. type .. "/" .. name .. ".lua")()
end

BEARO.UTILS.override = function(name)
	SMODS.load_file("src/overrides/" .. name .. ".lua")()
end

--- @param path string
BEARO.UTILS.include = function(path)
	SMODS.load_file(path)()
end

--- @param tbl table
BEARO.UTILS.largest_val = function(tbl)
	if not tbl or next(tbl) == nil then
		return nil
	end

	local mk, mv = next(tbl)

	for k, v in pairs(tbl) do
		if type(v) == "number" and v > mv then
			mk, mv = k, v
		end
	end

	return mk
end

--- @param context CalcContext
BEARO.UTILS.sort_jokers = function(context)
	local owned_joker_rets = {}

	for i, jkr in ipairs(G.jokers.cards) do
		local res = jkr:calculate_joker(context)
		table.insert(owned_joker_rets, res)
	end

	table.sort(owned_joker_rets, function(a, b)
		if a == nil then
			return false
		end
		if b == nil then
			return false
		end

		if type(a) == "number" and (a > 0 or a < 0) and a.chips then
			if type(b) ~= "number" then
				return true
			end
			return a > b
		elseif type(a) == "table" and a.mult then
			if type(b) ~= "table" or not b.mult then
				return true
			end
			return a.mult > b.mult
		elseif type(a) == "table" and (a.Xmult or a.Xmult_mod) then
			local amod = a.Xmult or a.Xmult_mod
			if type(b) ~= "table" or not (b.Xmult or b.Xmult_mod) then
				return true
			end
			local bmod = b.Xmult or b.Xmult_mod

			return amod > bmod
		end

		return false
	end)

	return owned_joker_rets
end

BEARO.UTILS.random_joker = function(seed, excluded_flags, banned_card, pool, no_undiscovered)
	excluded_flags = excluded_flags or { "hidden", "no_doe", "no_grc" }
	local selection = "n/a"
	local passes = 0
	local tries = 500

	while true do
		tries = tries - 1
		passes = 0

		local key = pseudorandom_element(pool or G.P_CENTER_POOLS.Joker, pseudoseed(seed or "grc")).key
		selection = G.P_CENTERS[key]

		if selection.discovered or not no_undiscovered then
			if not banned_card or (banned_card and banned_card ~= key) then
				passes = passes + 1
			end
		end

		if passes >= #excluded_flags or tries <= 0 then
			if tries <= 0 and no_undiscovered then
				return G.P_CENTERS.c_strength
			else
				return selection
			end
		end
	end
end

--- @param context CalcContext
--- @return string
BEARO.UTILS.suit_majority = function(context)
	local suit_counts = {}

	for _, suit in ipairs({ "Hearts", "Diamonds", "Clubs", "Spades" }) do
		suit_counts[suit] = 0
	end

	for _, card in ipairs(context.scoring_hand) do
		local suit = card.base.suit
		if suit_counts[suit] then
			suit_counts[suit] = suit_counts[suit] + 1
		end
	end

	local max_suit = "Hearts"
	local max_count = 0

	for suit, count in pairs(suit_counts) do
		if count > max_count then
			max_count = count
			max_suit = suit
		end
	end

	return max_suit
end

--- @param t table Table to reverse
--- @return table # Reverses the order of keys in a table
BEARO.UTILS.reverse_table = function(t)
	local reversed = {}

	for idx = #t, 1, -1 do
		table.insert(reversed, t[idx])
	end

	return reversed
end

--- @param hand_name string The name of the poker hand, e.g. "Flush Five"
--- @return string? #
BEARO.UTILS.get_planet_for_hand = function(hand_name)
	for _, v in ipairs(G.P_CENTER_POOLS.Planet) do
		if v.config and v.config.hand_type == hand_name then
			return v.key
		end
	end
end

--- @param ctx table | CalcContext
--- @return boolean # Whether or not the bossblind was just defeated
BEARO.UTILS.check_bossblind_just_defeated = function(ctx)
	if ctx.end_of_round and ctx.main_eval and G.GAME.blind.boss then
		return true
	else
		return false
	end
end

--- Get whether or not a card is rigged via the Cryptid mod
--- @param card Card
--- @return boolean
BEARO.UTILS.is_rigged_cryptid = function(card)
	if (SMODS.Mods["Cryptid"] or {}).can_load then
		return card.ability.cry_rigged
	else
		return false
	end
end

--- @param key string # The key for the new gradient
--- @param colors table<number, table<number, number>> # A list of colors
BEARO.UTILS.create_gradient = function(key, colors)
	return SMODS.Gradient({
		key = key,
		colours = colors,
	})
end

--- @param word string
--- @return string
BEARO.UTILS.capitalize = function(word)
	if not word or word == "" then
		return word
	end

	return word:sub(1, 1):upper() .. word:sub(2):lower()
end

--- @param context CalcContext
BEARO.UTILS.playing_card_context = function(context)
	return (context.cardarea == G.play and context.main_scoring)
end

--- Applies a modifer to all number values in a table
--- @param input table | number
--- @param modifier number
--- @return table | number
BEARO.UTILS.mod_vals = function(input, modifier)
	if type(input) == "number" then
		return input * modifier
	elseif type(input) == "table" then
		local result = {}

		for k, v in pairs(input) do
			result[k] = BEARO.UTILS.mod_vals(v, modifier)
		end

		return result
	else
		return input
	end
end

--- Gets whether or not you have all of the jokers specified with the jokers parameter
--- @param joker_keys table<string>
--- @return boolean
BEARO.UTILS.has_joker_combo = function(joker_keys)
	local has_jokers = true

	for _, v in joker_keys do
		if not SMODS.find_card(v, false) then
			has_jokers = false
		end
	end

	return has_jokers
end

-- Stolen from cryptid
--- @param name string
--- @param rarity string | table | nil
---@param ability string | table | nil
---@param edition SMODS.Edition
---@param non_debuff true
---@param area CardArea
BEARO.UTILS.find_joker_next = function(name, rarity, edition, ability, non_debuff, area)
	local jokers = {}
	local filter = 0
	if not G.jokers or not G.jokers.cards then
		return {}
	end
	if name then
		filter = filter + 1
	end
	if edition then
		filter = filter + 1
	end
	if type(rarity) ~= "table" then
		if type(rarity) == "string" then
			rarity = { rarity }
		else
			rarity = nil
		end
	end
	if rarity then
		filter = filter + 1
	end
	if type(ability) ~= "table" then
		if type(ability) == "string" then
			ability = { ability }
		else
			ability = nil
		end
	end
	if ability then
		filter = filter + 1
	end
	if filter == 0 then
		return {}
	end

	if not area or area == "j" then
		for k, v in pairs(G.jokers.cards) do
			if v and type(v) == "table" and (non_debuff or not v.debuff) then
				local check = 0
				if name and v.ability.name then
					check = check + 1
				end
				if edition and (v.edition and v.edition.key == edition) then
					check = check + 1
				end

				if rarity then
					for _, a in ipairs(rarity) do
						if v.config.center.rarity == a then
							check = check + 1
							break
						end
					end
				end

				if ability then
					local abil_check = true

					for _, b in ipairs(ability) do
						if not v.ability[b] then
							abil_check = false
							break
						end
					end

					if abil_check then
						check = check + 1
					end
				end

				if check == filter then
					table.insert(jokers, v)
				end
			end
		end
	end
end

--- Exponentiate `base` to the power of `power`
--- @param base number
--- @param power number
--- @return number
BEARO.UTILS.exponentiate = function(base, power)
	if power == 0 then
		return 1
	elseif power == 1 then
		return base
	elseif power < 0 then
		return 1 / BEARO.UTILS.exponentiate(base, -power)
	end

	local result = 1

	while power > 0 do
		if power % 2 == 1 then
			result = result * base
		end

		base = base * base
		power = math.floor(power / 2)
	end

	return result
end

--- Returns the sprite pos for the placeholder sprite when no art is available for a card.
--- @return table
BEARO.UTILS.placeholder_sprite = function()
	return {
		x = 19,
		y = 0,
	}
end

--- @param mod_cfg Mod
--- @return table
BEARO.UTILS.boobs_sprite = function(mod_cfg)
	if mod_cfg.config.adult_mode then
		return { x = 1000, y = 10000 }
	elseif not mod_cfg.config.adult_mode then
		return { x = 12, y = 2 }
	else
		return { x = 1000, y = 10000 }
	end
end

--- @param dt number
--- @param speed number
--- @param width number
--- @param height number
--- @param last_frame { x: number, y: number }
--- @param center SMODS.Center
BEARO.UTILS.anim_spr = function(dt, speed, width, height, last_frame, center)
	if dt > 0.1 then
		dt = 0

		local obj = center

		if obj.pos.x == width and obj.pos.y == height then
			obj.pos.x = 0
			obj.pos.y = 0
		elseif obj.pos.x < last_frame.x then
			obj.pos.x = obj.pos.x + 1
		elseif obj.pos.y < last_frame.y then
			obj.pos.x = 0
			obj.pos.y = obj.pos.y + 1
		end
	end
end

--- @param x number
--- @param y number
--- @param threshold number
BEARO.UTILS.within = function(x, y, threshold)
	return math.abs(x - y) <= x
end

BEARO.UTILS.mod_cond = function(mod_id, if_exists, otherwise)
	if (SMODS.Mods[mod_id] or {}).can_load then
		return if_exists
	else
		return otherwise
	end
end

--- @param card table | Card
--- @param context table | CalcContext
--- @return table?, boolean?
BEARO.UTILS.placeholder_calculate = function(card, context)
	local whoami = context.blueprint_card or card

	return {
		card = whoami,
		message = "PLACEHOLDER!",
		colour = G.C.SECONDARY_SET.Planet,
	}
end

--- @param enhanement SMODS.Enhancement
--- @return number
BEARO.UTILS.count_enhanced = function(enhanement)
	local counter = 0
	for _, v in pairs(G.playing_cards or {}) do
		if SMODS.has_enhancement(v, enhanement) then
			counter = counter + 1
		end
	end

	return counter
end

--- Shuffles the keys and values of a given table
--- @param tbl table The table to shuffle
--- @return table
BEARO.UTILS.every_day_im_shufflin = function(tbl)
	if type(tbl) ~= "table" then
		return tbl
	end

	--- @type table
	local values = {}

	--- @type table
	local paths = {}

	--- @param current table
	--- @param path string
	local function collect_values(current, path)
		for k, v in pairs(current) do
			local new_path = path .. "." .. k
			if type(v) == "table" then
				collect_values(v, new_path)
			else
				table.insert(values, v)
				table.insert(paths, new_path)
			end
		end
	end

	collect_values(tbl, "")

	for i = #values, 2, -1 do
		local j = math.random(i)
		values[i], values[j] = values[j], values[i]
	end

	--- @type integer
	local value_index = 1

	--- @param current table
	--- @param path string
	local function reconstruct(current, path)
		for k, v in pairs(current) do
			local new_path = path .. "." .. k
			if type(v) == "table" then
				reconstruct(v, new_path)
			else
				for i, p in ipairs(paths) do
					if p == new_path then
						if next(current) ~= nil and type(current[k]) ~= "table" then
							current = {}
						end

						break
					end
				end
			end
		end

		for k, v in pairs(current) do
			if type(v) ~= "table" then
				if value_index <= #values then
					current[k] = values[value_index]
					value_index = value_index + 1
				else
					current[k] = nil
				end
			end
		end

		if next(current) == nil and value_index <= #values then
			return values[value_index]
		end

		return current
	end

	local result = reconstruct(tbl, "")
	if type(result) ~= "table" then
		return result
	end

	return tbl
end

--- @return boolean
BEARO.UTILS.insolent_pool_check = function()
	if G.GAME and G.STAGE == G.STAGES.RUN then
		return G.GAME.round_resets.ante >= 256
	else
		return false
	end
end

--- @param prefix string
--- @param joker_key string
--- @return number
BEARO.UTILS.count_num_of_joker = function(prefix, joker_key)
	local joker_count = 0

	if G.jokers then
		for _, v in pairs(G.jokers.cards) do
			if v.ability.name == "j_" .. prefix .. "_" .. joker_key then
				joker_count = joker_count + 1
			end
		end
	end

	return joker_count
end

--- @param joker_key string
--- @return number
BEARO.UTILS.count_num_of_joker_bearo = function(joker_key)
	local joker_count = 0

	if G.jokers then
		for _, v in pairs(G.jokers.cards) do
			if v.ability.name == "j_bearo_" .. joker_key then
				joker_count = joker_count + 1
			end
		end
	end

	return joker_count
end

--- @return number
BEARO.UTILS.count_boobs = function()
	local number_of_boobs = 0

	for _, v in pairs(G.jokers.cards) do
		if v.ability.name == "j_bearo_boobs" then
			number_of_boobs = BEARO.UTILS.inc(number_of_boobs)
		end
	end

	return number_of_boobs
end

--- @param len number
--- @return string
BEARO.UTILS.random_str = function(len)
	local char_set = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%^"
	local random_string = ""

	for i = 1, len do
		-- math.randomseed(os.time() + i * 5)
		local rand_idx = math.random(1, #char_set)
		random_string = random_string .. char_set:sub(rand_idx, rand_idx)
	end

	return random_string
end

--- @param str_len number
--- @param tbl_len number
--- @return table
BEARO.UTILS.random_table_of_strs = function(str_len, tbl_len)
	local strs = {}

	for i = 1, tbl_len do
		-- math.randomseed(os.time() + i * 5)
		local rand_str = BEARO.UTILS.random_str(str_len)
		table.insert(strs, rand_str)
	end

	return strs
end

--- Generate a random Hex code
--- @return table
BEARO.UTILS.rand_hex_code = function()
	local r = math.random(0, 255)
	local g = math.random(0, 255)
	local b = math.random(0, 255)

	local hex_r = string.format("%02X", r)
	local hex_g = string.format("%02X", g)
	local hex_b = string.format("%02X", b)

	return HEX(hex_r .. hex_g .. hex_b)
end

--- @param colors number # The amount of colors to have in the table
--- @return table
BEARO.UTILS.rand_table_of_hex_codes = function(colors)
	local rand_colors = {}

	for i = 1, colors do
		local rand_hex = BEARO.UTILS.rand_hex_code()
		table.insert(rand_colors, rand_hex)
	end

	return rand_colors
end

--- @generic T
--- @param tbl table
--- @return T
BEARO.UTILS.choose_rand = function(tbl)
	if type(tbl) ~= "table" then
		error("Argument must be a table")
	end

	local keys = {}
	for k in pairs(tbl) do
		table.insert(keys, k)
	end

	if #keys == 0 then
		return nil
	end

	local rand_idx = math.random(1, #keys)
	return tbl[keys[rand_idx]]
end

--- @return boolean
BEARO.UTILS.rand_bool = function()
	return BEARO.UTILS.choose_rand({
		true,
		false,
	})
end

--- @return table
BEARO.UTILS.rand_color = function()
	return BEARO.UTILS.choose_rand(G.C)
end

--- @param min integer
--- @param max integer
BEARO.UTILS.rand_int = function(min, max)
	if min > max then
		error("min should be less than or equal to max")
	end

	return math.floor(math.random() * (max - min + 1)) + min
end

--- @param min number
--- @param max number
BEARO.UTILS.rand_num = function(min, max)
	if min > max then
		error("min should be less than or equal to max")
	end

	return math.random(min, max)
end

--- @param num number
--- @return number
BEARO.UTILS.inc = function(num)
	return num + 1
end

--- @param num number
--- @return number
BEARO.UTILS.dec = function(num)
	return num - 1
end

--- @param messages table<table<string, table>> # A table of messages to cycle through along with their respective colors
--- @param random boolean # Whether the cycling should be randomized or follow the order of the messages table
--- @param cycle_delay number # Time between cycled messages
--- @param text_scale number # The scale for the displayed text
--- @return table # The new DynaText object
BEARO.UTILS.cycling_text = function(messages, random, cycle_delay, text_scale)
	return {
		n = G.UIT.O,
		config = {
			object = DynaText({
				string = messages,
				colours = { G.C.BLUE },
				pop_in_rate = 99999999,
				silent = true,
				random_element = random,
				pop_delay = cycle_delay,
				min_cycle_time = 0,
				scale = text_scale,
			}),
		},
	}
end

--- @param num number
--- @return number
BEARO.UTILS.wave_number = function(num)
	if num == 0 then
		return 1
	elseif num > 0 then
		return -num - 1
	else
		return -num + 1
	end
end

--- @param num number
--- @param min number
--- @param max number
--- @return number
BEARO.UTILS.clamp = function(num, min, max)
	if num < min then
		return min
	elseif num > max then
		return max
	else
		return num
	end
end

--- @param chance number The percent chance to return true (must be a number between 0 and 100)
--- @return boolean
BEARO.UTILS.chance = function(chance)
	local rand_num = math.random(0, 100)
	return rand_num <= chance
end

--- @alias PatternFunc fun(value: any): boolean
--- @alias Pattern any | PatternFunc
--- @alias Handler any | fun(value: any): any

--- @param value any The value to match against
--- @param cases table<Pattern, Handler> A table of patterns and their handlers
--- @return any # The result of the matched handler
BEARO.UTILS.match = function(value, cases)
	for pattern, handler in pairs(cases) do
		if pattern == value then
			if type(handler) == "function" then
				return handler(value)
			else
				return handler
			end
		end
	end

	for pattern, handler in pairs(cases) do
		if type(pattern) == "function" and pattern(value) then
			if type(handler) == "function" then
				return handler(value)
			else
				return handler
			end
		end
	end

	if cases._ then
		if type(cases._) == "function" then
			return cases._(value)
		else
			return cases._
		end
	end

	error("non-exhaustive match: no case matched for value  " .. tostring(value))
end

-- Helper Patterns

--- @return boolean Always returns true
function BEARO.UTILS.H._()
	return true
end

--- @param x any
--- @return PatternFunc
function BEARO.UTILS.H.eq(x)
	return function(y)
		return x == y
	end
end

--- @param x any
--- @return PatternFunc
function BEARO.UTILS.H.ne(x)
	return function(y)
		return x ~= y
	end
end

--- @param x number
--- @return PatternFunc
function BEARO.UTILS.H.gt(x)
	return function(y)
		return y > x
	end
end

--- @param x number
--- @return PatternFunc
function BEARO.UTILS.H.lt(x)
	return function(y)
		return y < x
	end
end

--- @param x number
--- @return PatternFunc
function BEARO.UTILS.H.ge(x)
	return function(y)
		return y >= x
	end
end

--- @param x number
--- @return PatternFunc
function BEARO.UTILS.H.le(x)
	return function(y)
		return y <= x
	end
end

_ = BEARO.UTILS.H._
