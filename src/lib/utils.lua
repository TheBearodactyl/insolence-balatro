local ffi = require("ffi")
local lovely = require("lovely")

--- @diagnostic disable: duplicate-set-field

BEARO.UTILS = {}
BEARO.UTILS.H = {}

--- @alias inclty
--- | "achievements" # An Achievement
--- | "consumables"  # A Consumable
--- | "deck"         # A Deck
--- | "editions"     # An Edition
--- | "enhancements" # An Enhancement
--- | "jokers"       # A Joker
--- | "rarities"     # A Rarity
--- | "tweaks"       # A Tweak
--- | "stakes"       # A Stake
--- | "poker_hands"  # A Poker Hand
--- | "blinds"       # A Blind
--- | "pirate_ships" # A Pirate Ship

--- @param name string
--- @param type inclty
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

--- @param card Card
--- @param shader string
BEARO.UTILS.editionless_shader = function(card, shader)
	if card.config.center.discovered or card.bypass_discovery_center then
		card.children.center:draw_shader("bearo_" .. shader, nil, card.ARGS.send_to_shader)
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

BEARO.UTILS.mod_cond = function(mod_id, if_exists, otherwise)
	if (SMODS.Mods[mod_id] or {}).can_load then
		return if_exists
	else
		return otherwise
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
BEARO.UTILS.rand_int = insolib.rand_int

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

--- @param key string
--- @return boolean
BEARO.UTILS.is_pirate_ship = function(key)
	for _, v in ipairs(BEARO.ENABLED_PIRATE_SHIPS) do
		if "bearo_" .. v == key then
			return true
		end
	end

	return false
end

BEARO.UTILS.unorig_cent = function()
	return G.P_CENTERS["m_bearo_unoriginal_art"]
end

--- @alias locale
--- | "de"
--- | "en-us"
--- | "es_419"
--- | "es_ES"
--- | "fr"
--- | "id"
--- | "it"
--- | "ja"
--- | "ko"
--- | "nl"
--- | "pl"
--- | "pt_BR"
--- | "ru"
--- | "zh_CN"
--- | "zh_TW"

--- @param language locale
--- @param link string
BEARO.UTILS.localize_shader = function(language, link)
	return BEARO.UTILS.match(language, {
		["de"] = "Schattierung: " .. link,
		["en-us"] = "Shader: " .. link,
		["es_419"] = "Shadér: " .. link,
		["es_ES"] = "Shader: " .. link,
		["fr"] = "Shader: " .. link,
		["id"] = "Shade: " .. link,
		["it"] = "Shaders: " .. link,
		["ko"] = "셔더: " .. link,
		["ja"] = "シェーダー: " .. link,
		["nl"] = "Shader: " .. link,
		["pl"] = "Szlachetny: " .. link,
		["pt_BR"] = "Efeito: " .. link,
		["ru"] = "Шейдер: " .. link,
		["zh_CN"] = "着色器: " .. link,
		["zh_TW"] = "陰影: " .. link
	})
end

_ = BEARO.UTILS.H._
