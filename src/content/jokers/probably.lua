SMODS.Joker({
    key = "probably",
    atlas = "jokers",
    pos = { x = 9, y = 0 },
    soul_pos = { x = 10, y = 0 },
    cost = 25,
    rarity = "insolent",
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    loc_txt = {
        ["en-us"] = {
            name = "Lucky 7's",
            text = {
                "{X:green,C:white}Luck{}",
                "{X:green,C:white}Incarnate.{}",
            },
        },
    },
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.probabilities) do
            G.GAME.probabilities[k] = v * 1e307
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.probabilities) do
            G.GAME.probabilities[k] = v / 1e307
        end
    end,
})

function poll_edition(_key, _mod, _no_neg, _guaranteed)
    _mod = _mod or 1
    local edition_poll = pseudorandom(pseudoseed(_key or "edition_generic"))
    local poly_or_neg = pseudorandom("Poly or Neg", 1, 10)

    if libinsolence.count_num_of_joker("ins", "probably") >= 1 then
        if poly_or_neg > 5 then
            return { polychrome = true }
        else
            return { negative = true }
        end
    else
        if _guaranteed then
            if edition_poll > 1 - 0.003 * 25 and not _no_neg then
                return { negative = true }
            elseif edition_poll > 1 - 0.006 * 25 then
                return { polychrome = true }
            elseif edition_poll > 1 - 0.02 * 25 then
                return { holo = true }
            elseif edition_poll > 1 - 0.04 * 25 then
                return { foil = true }
            end
        else
            if edition_poll > 1 - 0.003 * _mod and not _no_neg then
                return { negative = true }
            elseif edition_poll > 1 - 0.006 * G.GAME.edition_rate * _mod then
                return { polychrome = true }
            elseif edition_poll > 1 - 0.02 * G.GAME.edition_rate * _mod then
                return { holo = true }
            elseif edition_poll > 1 - 0.04 * G.GAME.edition_rate * _mod then
                return { foil = true }
            end
        end
    end

    return nil
end

local orig_cc = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if libinsolence.count_num_of_joker("ins", "probably") >= 1 then
        if libinsolence.chance(50) then
            return orig_cc(_type, area, true, _rarity, skip_materialize, soulable, forced_key, key_append)
        else
            return orig_cc("Joker", area, legendary, 3, skip_materialize, soulable, forced_key, key_append)
        end
    else
        return orig_cc(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    end
end

local function choose_rand(arr)
    if #arr == 0 then
        return nil
    end

    local rand_idx = math.random(1, #arr)

    return arr[rand_idx]
end

local orig_gp = get_pack
function get_pack(_key, _type)
    local ret = orig_gp(_key, _type)

    local mega_packs = {
        "p_arcana_mega_1",
        "p_arcana_mega_2",
        "p_celestial_mega_1",
        "p_celestial_mega_2",
        "p_spectral_mega_1",
        "p_standard_mega_1",
        "p_standard_mega_2",
        "p_buffoon_mega_1",
    }

    if libinsolence.count_num_of_joker("ins", "probably") >= 1 then
        local pack_key = choose_rand(mega_packs) or "p_spectral_mega_1"

        return G.P_CENTERS[pack_key]
    end

    return ret
end
