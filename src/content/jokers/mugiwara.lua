-- Music code taken from Neato Jokers

local music_countdown = G.TIMERS.UPTIME
SMODS.Sound {
    key = "overthetop_music",
    path = "Over the Top.mp3",
    volume = 5,
    pitch = 1,
    select_music_track = function(self)
        if BEARO.MOD.config.mugiwara_music == 1 then
            -- Always Enabled
            return 100
        elseif BEARO.MOD.config.mugiwara_music == 2 and #SMODS.find_card("j_bearo_mugiwara") > 0 then
            -- Enable when Mugiwara present
            return 100
        elseif BEARO.MOD.config.mugiwara_music == 3 and music_countdown > G.TIMERS.UPTIME then
            return 100
        else
        end
    end
}


SMODS.Joker {
    key = "mugiwara",
    rarity = "insolent",
    pos = { x = 3, y = 0 },
    atlas = "jokers",
    cost = 100,
    config = {},
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    order = 5,
    eternal_compat = false,
    perishable_compat = false,
    soul_pos = { x = 11, y = 0 },
    in_pool = function(self, args)
        return BEARO.UTILS.insolent_pool_check()
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            music_countdown = G.TIMERS.UPTIME + 10.3

            local juice_while = function()
                return BEARO.MOD.config.mugiwara_music == 3
                    and G.SETTINGS.SOUND.volume > 0
                    and G.SETTINGS.SOUND.music_volume > 0
                    and music_countdown > G.TIMERS.UPTIME
            end

            if juice_while() then
                juice_card_until(card, juice_while)
            end
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main and not context.repetition and G.GAME and G.jokers then
            local jokers_count = #G.jokers.cards
        end
    end
}
