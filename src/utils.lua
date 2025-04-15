local utf8 = require("utf8")

--- @diagnostic disable: duplicate-set-field

BEARO.UTILS = {}
BEARO.UTILS.H = {}

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
    return SMODS.Gradient {
        key = key,
        colours = colors
    }
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
        y = 0
    }
end

--- @param mod_cfg Mod
--- @return table
BEARO.UTILS.boobs_sprite = function(mod_cfg)
    if mod_cfg.config.adult_mode then
        return { x = 12, y = 0 }
    elseif not mod_cfg.config.adult_mode then
        return BEARO.UTILS.placeholder_sprite()
    else
        return BEARO.UTILS.placeholder_sprite()
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
        colour = G.C.SECONDARY_SET.Planet
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

    local values = {}
    local paths = {}

    local function collect_values(current, path)
        for k, v in pairs(current) do
            local new_path = path .. '.' .. k
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

    local value_index = 1
    local function reconstruct(current, path)
        for k, v in pairs(current) do
            local new_path = path .. '.' .. k
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

--- @param joker_key string
--- @return number
BEARO.UTILS.count_num_of_joker = function(joker_key)
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

--- @param tbl table
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
        false
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
function BEARO.UTILS.H._() return true end

--- @param x any
--- @return PatternFunc
function BEARO.UTILS.H.eq(x) return function(y) return x == y end end

--- @param x any
--- @return PatternFunc
function BEARO.UTILS.H.ne(x) return function(y) return x ~= y end end

--- @param x number
--- @return PatternFunc
function BEARO.UTILS.H.gt(x) return function(y) return y > x end end

--- @param x number
--- @return PatternFunc
function BEARO.UTILS.H.lt(x) return function(y) return y < x end end

--- @param x number
--- @return PatternFunc
function BEARO.UTILS.H.ge(x) return function(y) return y >= x end end

--- @param x number
--- @return PatternFunc
function BEARO.UTILS.H.le(x) return function(y) return y <= x end end

_ = BEARO.UTILS.H._
