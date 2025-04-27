local music_countdown = G.TIMERS.UPTIME
SMODS.Sound {
    key = "samlaskey_music",
    path = "samlaskey.mp3",
    volume = 5,
    pitch = 1,
    select_music_track = function(self)
        if BEARO.MOD.config.samlaskey_music == 1 then
            -- Always Enabled
            return 100
        elseif BEARO.MOD.config.samlaskey_music == 2 and #SMODS.find_card("j_bearo_samlaskey") > 0 then
            -- Enable when samlaskey present
            return 100
        elseif BEARO.MOD.config.samlaskey_music == 3 and music_countdown > G.TIMERS.UPTIME then
            return 100
        else
        end
    end
}

SMODS.Joker {
    key = "samlaskey",
    rarity = "insolent",
    pos = {
        x = 1,
        y = 1
    },
    soul_pos = {
        x = 2,
        y = 1
    },
    atlas = "jokers",
    cost = 100,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    config = {
        extra = {
            rental_rate_mod = 20
        }
    },
    loc_txt = {
        ["en-us"] = {
            name = "Sam Laskey",
            text = {
                "Applies the following buffs:",
                " -> Cards cannot be {C:attention}Debuffed{}",
                " -> Rentals give {C:gold}$20{}",
                -- " -> Perishables {C:attention}duplicate{} after {C:green}10{} {C:attention}rounds{}"
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.extra.rental_rate_mod
            }
        }
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            music_countdown = G.TIMERS.UPTIME + 10.3

            local juice_while = function()
                return BEARO.MOD.config.samlaskey_music == 3
                    and G.SETTINGS.SOUND.volume > 0
                    and G.SETTINGS.SOUND.music_volume > 0
                    and music_countdown > G.TIMERS.UPTIME
            end

            if juice_while() then
                juice_card_until(card, juice_while)
            end

            function Card:calculate_rental()
                if self.ability.rental then
                    ease_dollars(self.config.extra.rental_rate_mod)
                    card_eval_status_text(self, "dollars", self.config.extra.rental_rate_mod)
                end
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        function Card:calculate_rental()
            if self.ability.rental then
                ease_dollars(-G.GAME.rental_rate)
                card_eval_status_text(self, "dollars", -G.GAME.rental_rate)
            end
        end
    end
}
