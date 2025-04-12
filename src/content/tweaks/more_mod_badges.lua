-- taken from jen

local function calculate_scalefactor(text)
    local size = 0.9
    local font = G.LANG.font
    local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
    local calced_text_width = 0
    for _, c in utf8.chars(text) do
        local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE +
        2.7 * 1 * G.TILESCALE * font.FONTSCALE
        calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
    end
    local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
    return scale_fac
end

---@diagnostic disable: duplicate-set-field
local smcmb = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
    smcmb(obj, badges)

    if obj and obj.misc_badge then
        local scale_fac = {}
        local scale_fac_len = 1
        if obj.misc_badge and obj.misc_badge.text then
            for i = 1, #obj.misc_badge.text do
                local calced_scale = calculate_scalefactor(obj.misc_badge.text[i])
                scale_fac[i] = calced_scale
                scale_fac_len = math.min(scale_fac_len, calced_scale)
            end
        end
        local ct = {}
        for i = 1, #obj.misc_badge.text do
            ct[i] = {
                string = obj.misc_badge.text[i]
            }
        end
        badges[#badges + 1] = {
            n = G.UIT.R,
            config = { align = "cm" },
            nodes = {
                {
                    n = G.UIT.R,
                    config = {
                        align = "cm",
                        colour = obj.misc_badge and obj.misc_badge.colour or G.C.RED,
                        r = 0.1,
                        minw = 2 / scale_fac_len,
                        minh = 0.36,
                        emboss = 0.05,
                        padding = 0.03 * 0.9,
                    },
                    nodes = {
                        { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                        {
                            n = G.UIT.O,
                            config = {
                                object = DynaText({
                                    string = ct or "ERROR",
                                    colours = { obj.misc_badge and obj.misc_badge.text_colour or G.C.WHITE },
                                    silent = true,
                                    float = true,
                                    shadow = true,
                                    offset_y = -0.03,
                                    spacing = 1,
                                    scale = 0.33 * 0.9,
                                }),
                            },
                        },
                        { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                    },
                },
            },
        }
    end
    if obj then
        for k, v in pairs(BEARO.MODIFIER_BADGES) do
            if obj[k] and obj[k] ~= nil then
                local scale_fac = {}
                local scale_fac_len = 1
                if v.text then
                    for i = 1, #v.text do
                        local calced_scale = calculate_scalefactor(v.text[i])
                        scale_fac[i] = calced_scale
                        scale_fac_len = math.min(scale_fac_len, calced_scale)
                    end
                end
                local ct = {}
                for i = 1, #v.text do
                    ct[i] = {
                        string = v.text[i]
                    }
                end
                badges[#badges + 1] = {
                    n = G.UIT.R,
                    config = { align = "cm" },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {
                                align = "cm",
                                colour = v and v.col or G.C.RED,
                                r = 0.1,
                                minw = 2 / scale_fac_len,
                                minh = 0.36,
                                emboss = 0.05,
                                padding = 0.03 * 0.9,
                            },
                            nodes = {
                                { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                                {
                                    n = G.UIT.O,
                                    config = {
                                        object = DynaText({
                                            string = ct or "ERROR",
                                            colours = { v and v.tcol or G.C.WHITE },
                                            silent = true,
                                            float = true,
                                            shadow = true,
                                            offset_y = -0.03,
                                            spacing = 1,
                                            scale = 0.33 * 0.9,
                                        }),
                                    },
                                },
                                { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                            },
                        },
                    },
                }
            end
        end
    end
end
