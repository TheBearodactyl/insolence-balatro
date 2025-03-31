BEARO.UTILS = {}

--- @param t table
--- @return table
BEARO.UTILS.reverse_table = function(t)
    local reversed = {}

    for idx = #t, 1, -1 do
        table.insert(reversed, t[idx])
    end

    return reversed
end

--- @param hand_name string The name of the poker hand, e.g. "Flush Five"
--- @return string?
BEARO.UTILS.get_planet_for_hand = function (hand_name)
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

--- @param card Card
--- @return boolean
BEARO.UTILS.is_rigged_cryptid = function(card)
    if (SMODS.Mods["Cryptid"] or {}).can_load then
        return card.ability.cry_rigged
    else
        return false
    end
end