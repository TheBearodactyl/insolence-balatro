--- @type boolean # Whether or not the player has the Probably joker
HAS_PROBABLY = false

SMODS.Joker {
    key = "probably",
    atlas = "jokers",
    pos = { x = 9, y = 0 },
    soul_pos = { x = 10, y = 0 },
    cost = 25,
    rarity = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    loc_txt = {
        ["en-us"] = {
            name = "Lucky 7's",
            text = {
                "Luck Incarnate."
            }
        }
    },
    add_to_deck = function(self, card, from_debuff)
        HAS_PROBABLY = true

        for k, v in pairs(G.GAME.probabilities) do
            G.GAME.probabilities[k] = v * 1e307
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        HAS_PROBABLY = false

        for k, v in pairs(G.GAME.probabilities) do
            G.GAME.probabilities[k] = v / 1e307
        end
    end
}

function poll_edition(_key, _mod, _no_neg, _guaranteed)
    _mod = _mod or 1
    local edition_poll = pseudorandom(pseudoseed(_key or "edition_generic"))
    local poly_or_neg = pseudorandom("Poly or Neg", 1, 10)

    if HAS_PROBABLY then
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
