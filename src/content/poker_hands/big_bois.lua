-- copied from cryptid lmao
local pokerhandinforef = G.FUNCS.get_poker_hand_info
function G.FUNCS.get_poker_hand_info(_cards)
    local text, loc_disp_text, poker_hands, scoring_hand, disp_text = pokerhandinforef(_cards)
    if G.SETTINGS.language == "en-us" then
        if #scoring_hand > 5 and (text == "Flush Five" or text == "Five of a Kind") then
            local rank_array = {}
            local county = 0
            for i = 1, #scoring_hand do
                local val = scoring_hand[i]:get_id()
                rank_array[val] = (rank_array[val] or 0) + 1
                if rank_array[val] > county then
                    county = rank_array[val]
                end
            end
            local function create_num_chunk(int)
                if int >= 1000 then
                    int = 999
                end
                local ones = {
                    ["1"] = "One",
                    ["2"] = "Two",
                    ["3"] = "Three",
                    ["4"] = "Four",
                    ["5"] = "Five",
                    ["6"] = "Six",
                    ["7"] = "Seven",
                    ["8"] = "Eight",
                    ["9"] = "Nine",
                }
                local tens = {
                    ["1"] = "Ten",
                    ["2"] = "Twenty",
                    ["3"] = "Thirty",
                    ["4"] = "Forty",
                    ["5"] = "Fifty",
                    ["6"] = "Sixty",
                    ["7"] = "Seventy",
                    ["8"] = "Eighty",
                    ["9"] = "Ninety",
                }
                local str_int = string.reverse(int .. "") -- ehhhh whatever
                local str_ret = ""
                for i = 1, string.len(str_int) do
                    local place = str_int:sub(i, i)
                    if place ~= "0" then
                        if i == 1 then
                            str_ret = ones[place]
                        elseif i == 2 then
                            if place == "1" and str_ret ~= "" then -- admittedly not my smartest moment, i dug myself into a hole here...
                                if str_ret == "One" then
                                    str_ret = "Eleven"
                                elseif str_ret == "Two" then
                                    str_ret = "Twelve"
                                elseif str_ret == "Three" then
                                    str_ret = "Thirteen"
                                elseif str_ret == "Five" then
                                    str_ret = "Fifteen"
                                elseif str_ret == "Eight" then
                                    str_ret = "Eighteen"
                                else
                                    str_ret = str_ret .. "teen"
                                end
                            else
                                str_ret = tens[place] .. ((string.len(str_ret) > 0 and " " or "") .. str_ret)
                            end
                        elseif i == 3 then
                            str_ret = ones[place]
                                .. (" Hundred" .. ((string.len(str_ret) > 0 and " and " or "") .. str_ret))
                        end
                    end
                end
                return str_ret
            end
            loc_disp_text = (text == "Flush Five" and "Flush " or "")
                .. (
                    (county < 1000 and create_num_chunk(county) or "Thousand")
                    .. (text == "Five of a Kind" and " of a Kind" or "")
                )
        end
    end
    local hand_table = {
        ["High Card"] = 1 or nil,
        ["Pair"] = 2 or nil,
        ["Two Pair"] = 4,
        ["Three of a Kind"] = 3 or nil,
        ["Straight"] = next(SMODS.find_card("j_four_fingers")) and 4 or 5,
        ["Flush"] = next(SMODS.find_card("j_four_fingers")) and 4 or 5,
        ["Full House"] = 5,
        ["Four of a Kind"] = 4 or nil,
        ["Straight Flush"] = next(SMODS.find_card("j_four_fingers")) and 4 or 5, --debatable
        ["cry_Bulwark"] = 5,
        ["Five of a Kind"] = 5,
        ["Flush House"] = 5,
        ["Flush Five"] = 5,
    }

    return text, loc_disp_text, poker_hands, scoring_hand, disp_text
end
