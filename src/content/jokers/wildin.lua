SMODS.Joker {
    key = "wildin",
    atlas = "jokers",
    rarity = 2,
    cost = 4,
    pos = libinsolence.placeholder_sprite(),
    loc_txt = {
        ["en-us"] = {
            name = "Wildin'",
            text = {
                "Wild Cards cannot",
                "be debuffed"
            }
        }
    },
}

local orig_csd = Card.set_debuff
function Card:set_debuff(should_debuff)
    if libinsolence.count_num_of_joker("ins", "wildin") >= 1 and self.ability and self.ability.name == "Wild Card" then
        should_debuff = false
    end

    orig_csd(self, should_debuff)
end