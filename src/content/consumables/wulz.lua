SMODS.Consumable({
    key = "wulz",
    atlas = "consumables",
    pos = { x = 2, y = 0 },
    config = {
        mod_conv = "m_ins_woah_enh"
    },
    cost = 3,
    set = "Tarot",
    order = 14,
    loc_txt = {
        ["en-us"] = {
            name = "The Wulz",
            text = {
                "Adds the {C:attention}Woah{} enhancement",
                "to up to {C:green}2{} selected playing cards",
            },
        },
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[self.config.mod_conv]
    end,
    can_use = function(self, card)
        return (#G.hand.highlighted <= 2 and #G.hand.highlighted > 0)
    end,
})
