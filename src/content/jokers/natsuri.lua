SMODS.Joker {
    key = "natsuri",
    atlas = "natsurianim",
    pos = {
        x = 0,
        y = 0
    },
    cost = 50,
    rarity = "insolent",
    natsuri = true,
    config = {
        extra = {
            emult = 3
        }
    },
    loc_txt = {
        ["en-us"] = {
            name = "Natsuri",
            text = {
                "All {C:attention}Lesbian{} cards give",
                "an additional {X:planet,C:white,s:5}^#1#{} Mult",
            },
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["e_ins_lesbian_ed"]

        return {
            vars = {
                self.config.extra.emult
            }
        }
    end,
    in_pool = function (self, args)
        local num_of_lesbian_cards = 0

        if G.deck then
            for k, v in pairs(G.deck.cards) do
                --- @type Card
                v = v

                if v.edition and v.edition.key == "e_ins_lesbian_ed" then
                    num_of_lesbian_cards = num_of_lesbian_cards + 1
                end
            end
        end

        return num_of_lesbian_cards >= 2
    end,
    calculate = function(self, card, context)
        if
            context.other_joker
            and context.other_joker.edition
            and context.other_joker.edition.key == "e_ins_lesbian_ed"
            and card ~= context.other_joker
        then
            return {
                message = "GIRLS KISSING",
                Emult_mod = self.config.extra.emult,
            }
        end

        if context.individual and context.cardarea == G.play then
            if context.other_card.edition and context.other_card.edition.key == "e_ins_lesbian_ed" then
                return {
                    emult = self.config.extra.emult,
                    colour = G.C.PURPLE,
                    card = card,
                }
            end
        end
    end
}