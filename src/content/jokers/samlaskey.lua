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
        elseif BEARO.MOD.config.samlaskey_music == 4 and music_countdown > G.TIMERS.UPTIME then
            return 100
        else
        end
    end
}

local orig_cc = create_card

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
            rental_rate_mod = 3
        }
    },
    loc_txt = {
        ["en-us"] = {
            name = "Sam Laskey",
            text = {
                "{C:attention}Rentals{} give {C:gold}$#1#{}",
                "All cards are {C:attention}Rental{}"
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
        local music_dur = 20
        if BEARO.UTILS.count_num_of_joker_bearo("samlaskey") >= 1 then
            music_dur = 199
        end

        if not from_debuff then
            music_countdown = G.TIMERS.UPTIME + music_dur

            local juice_while = function()
                if BEARO.MOD.config.samlaskey_music == 3 then
                    return G.SETTINGS.SOUND.volume > 0
                        and G.SETTINGS.SOUND.music_volume > 0
                        and music_countdown > G.TIMERS.UPTIME
                elseif BEARO.MOD.config.samlaskey_music == 4 then
                    return G.SETTINGS.SOUND.volume > 0
                        and G.SETTINGS.SOUND.music_volume > 0
                        and music_countdown > G.TIMERS.UPTIME
                end
            end

            if juice_while() then
                juice_card_until(card, juice_while)
            end

            G.GAME.rental_rate = -3
            G.GAME.modifiers.enable_rentals_in_shop = true
            function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
                local ret = orig_cc(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)

                ret:set_rental(true)

                return ret
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.rental_rate = 3
        function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
            return orig_cc(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        end
    end
}

G.FUNCS.has_laskey = function()
    if G.jokers and BEARO then
        if BEARO.UTILS.count_num_of_joker("bearo", "j_bearo_samlaskey") >= 1 then
            return true
        else
            return false
        end
    end

    return false
end
