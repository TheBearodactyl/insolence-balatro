SMODS.Blind {
    key = "chrisrock",
    atlas = "chrisrockatlas",
    pos = {
        x = 0, y = 0
    },
    boss = {
        showdown = true
    },
    boss_colour = G.C.RED,
    loc_txt = {
        ["en-us"] = {
            name = "Chris Rock",
            text = {
                "Everything is debuffed",
                "unless you've beaten",
                "{C:attention}Will Smith"
            }
        }
    },
    set_blind = function(self)
        if BEARO.defeated_will_smith == true then
            G.E_MANAGER:add_event(Event {
                trigger = "after",
                func = function()
                    self:defeat()

                    return true
                end
            })
        end
    end
}
