SMODS.Achievement({
    key = "grow_boobs",
    atlas = "jokers",
    pos = libinsolence.boobs_sprite(insolence.mod),
    order = 6,
    loc_txt = {
        ["en-us"] = {
            name = "Grow Boobs",
            description = "Obtain at least 2 boobs",
        },
    },
    unlock_condition = function(self, args)
        if args.type == "modify_jokers" then
            if G.jokers then
                local boobs_count = libinsolence.count_num_of_joker("ins", "boobs")

                if boobs_count >= 2 then
                    return true
                end
            end
        end
    end,
})
