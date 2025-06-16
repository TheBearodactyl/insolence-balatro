local orig_gu = Game.update

local garry_dt = 0
function Game:update(dt)
    orig_gu(self, dt)

    garry_dt = garry_dt + dt

    if G.P_CENTERS and G.P_CENTERS["j_ins_garry"] and garry_dt > 0.1 then
        garry_dt = 0

        local garry_obj = G.P_CENTERS["j_ins_garry"]

        if garry_obj.pos.x == 8 and garry_obj.pos.y == 3 then
            garry_obj.pos.x = 0
            garry_obj.pos.y = 0
        elseif garry_obj.pos.x < 9 then
            garry_obj.pos.x = garry_obj.pos.x + 1
        elseif garry_obj.pos.y < 4 then
            garry_obj.pos.x = 0
            garry_obj.pos.y = garry_obj.pos.y + 1
        end
    end
end

SMODS.Joker({
	key = "garry",
	atlas = "gmod",
	pos = { x = 0, y = 0 },
	cost = 50,
	rarity = 3,
	loc_txt = {
		["en-us"] = {
			name = "GMOD",
			text = {
				"Create a {C:chips}Blueprint{} after",
				"5 {C:attention}rounds{} {C:inactive{}(#1#){}",
				" ",
				"{C:red}Self Destructs{}",
			},
		},
	},
	config = {
		extra = {
			rounds_left = 5,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.rounds_left,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
			card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1

			if card.ability.extra.rounds_left == 0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						local bp = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_blueprint")
						bp:add_to_deck()
						G.jokers:emplace(bp)

						return true
					end,
				}))

				card:start_dissolve()

				return {
					card = card,
					message = "brian look out nooooo",
				}
			end
		end
	end,
})
