BEARO.ENABLED_PIRATE_SHIPS = {
    "going_merry",
    "thousand_sunny"
}

BEARO.PirateShip = SMODS.Sticker:extend {
    prefix_config = { key = true },
    should_apply = false,
    config = {},
    rate = 0,
    sets = {
        Default = true,
    },
    draw = function(self, card, layer)
        local x_off = (card.T.w / 71) * -4 * card.T.scale

        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader("dissolve", nil, nil, nil, card.children.center, nil, nil, x_off)
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val and copy_table(self.config) or nil
    end
}

local function pirate_ships_ui()
    local pirate_ships = {}

    for k, v in pairs(SMODS.Stickers) do
        if BEARO.UTILS.is_pirate_ship(k) then
            pirate_ships[k] = v
        end
    end

    return SMODS.card_collection_UIBox(pirate_ships, { 5, 5 }, {
        snap_back = true,
        hide_single_page = true,
        collapse_single_page = true,
        center = "c_base",
        h_mod = 1.18,
        back_func = "your_collection_other_gameobjects",
        modify_card = function(card, center)
            card.ignore_pinned = true
            center:apply(card, true)
        end
    })
end

G.FUNCS.your_collection_insolence_pirateships = function()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu {
        definition = pirate_ships_ui()
    }
end