BEARO.boobs = 0

--- @param ed_key string
--- @return string
local function boobs_loc(ed_key)
    return BEARO.UTILS.match(ed_key, {
        ["e_foil"] = "A FOIL",
        ["e_holo"] = "A HOLOGRAPHIC",
        ["e_polychrome"] = "A POLYCHROME",
        ["e_negative"] = "A NEGATIVE",
        ["e_bearo_ace_ed"] = "AN ACE",
        ["e_bearo_aurora_ed"] = "AN AURORA",
        ["e_bearo_bisexual_ed"] = "A BI",
        ["e_bearo_bugged_ed"] = "A " .. BEARO.UTILS.random_str(9),
        ["e_bearo_cellular_ed"] = "A SINGLE CELL",
        ["e_bearo_edgy_ed"] = "an edgy......",
        ["e_bearo_gay_ed"] = "A GAY",
        ["e_bearo_lesbian_ed"] = "A LESBIAN",
        ["e_bearo_trans_ed"] = "A TRANS",
        ["e_bearo_universe_ed"] = "A MULTIVERSAL",
        ["e_bearo_vaporwave_ed"] = "A VAPORWAVE",
        ["e_bearo_voronoi_ed"] = "A VORONOI (?)",
        [_] = ""
    })
end

SMODS.Joker {
    key = "boobs",
    atlas = "jokers",
    pos = BEARO.UTILS.boobs_sprite(BEARO.MOD),
    order = 70,
    config = {
        extra = {
            name = "a",
            chips = 80
        }
    },
    loc_txt = {
        ["en-us"] = {
            name = "#1#",
            text = {
                "Gives {C:chips}+#2#{} chips",
                "{C:inactive}(increses to {}{C:chips}8008{}{C:inactive} if 2 boobs are owned){}"
            }
        }
    },
    rarity = 2,
    cost = 10,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        if card.edition then
            local boob_prefix = boobs_loc(card.edition.key)
            local msg = ""

            if boob_prefix == "" then
                msg = "A BOOB! WOW!"
            else
                msg = boob_prefix .. " BOOB! WOW!"
            end

            return {
                vars = {
                    msg,
                    self.config.extra.chips
                }
            }
        else
            return {
                vars = {
                    "A BOOB! WOW!",
                    self.config.extra.chips
                }
            }
        end
    end,
    update = function(self, card, dt)
        local boobs_count = 0

        if G.jokers then
            for _, v in pairs(G.jokers.cards) do
                if v.ability.name == "j_bearo_boobs" then
                    boobs_count = boobs_count + 1
                end
            end
        end

        if boobs_count <= 1 then
            self.config.extra.chips = 80
        elseif boobs_count >= 2 then
            self.config.extra.chips = 8008
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = "(. Y .)",
                chips = self.config.extra.chips,
                card = card
            }
        end
    end
}
