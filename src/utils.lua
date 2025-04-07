--- @diagnostic disable: duplicate-set-field

BEARO.UTILS = {}

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

--- Get whether or not 
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
        return G.GAME.round_resets.ante >= 39
    else
        return false
    end
end