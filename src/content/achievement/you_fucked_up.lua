SMODS.Achievement {
    key = "you_fucked_up_lol",
    order = 6,
    bypass_all_unlocked = true,
    atlas = "achievements",
    unlock_condition = function(self, args)
        if args.type == "fucked_up" then
            return true
        end
    end
}