SMODS.Shader({
	key = "bugged",
	path = "bugged.fs",
})

local bugged_gradient = BEARO.UTILS.create_gradient("bugged_grad", BEARO.UTILS.rand_table_of_hex_codes(5))

local function bugged_calc()
	local rand_num = math.random() * 20 - 10 -- Between -10 and 10
	local op = math.random(4)

	if op == 1 then
		rand_num = rand_num + math.random() * 50 - 25 -- Between -25 and 25
	elseif op == 2 then
		rand_num = rand_num * (math.random() * 2 + 0.5)
	elseif op == 3 then
		rand_num = rand_num / (math.random() * 2 + 0.5)
	else
		rand_num = math.sin(rand_num) * 100
	end

	local lower_bound = math.random() * 40 - 20
	local upper_bound = math.random() * 40 - 20

	if lower_bound > upper_bound then
		local temp = lower_bound
		lower_bound = upper_bound
		upper_bound = temp
	end

	return math.max(lower_bound, math.min(upper_bound, rand_num))
end

SMODS.Edition({
	key = "bugged_ed",
	shader = "bugged",
	config = {
		extra = {
			mult = 0,
			chips = 0,
			xmult = 0,
			trigger = nil,
		},
	},
	badge_colour = bugged_gradient,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				self.config.extra.mult,
				self.config.extra.chips,
				self.config.extra.xmult,
			},
		}
	end,
	loc_txt = {
		["en-us"] = {
			name = "Bugged",
			label = BEARO.UTILS.random_str(12),
			text = { "{C:mult}+#1#{} Mult", "{C:chips}+#2#{} Chips", "{C:mult}X#3#{} Mult" },
		},
	},
	calculate = function(self, card, context)
		if
			(context.edition and context.cardarea == G.jokers and self.config.extra.trigger)
			or (context.main_scoring and context.cardarea == G.play)
		then
			self.config.extra.mult = bugged_calc()
			self.config.extra.chips = bugged_calc()
			self.config.extra.xmult = bugged_calc()

			return {
				mult = self.config.extra.mult,
				chips = self.config.extra.chips,
				Xmult_mod = self.config.extra.xmult,
			}
		end

		if context.joker_main then
			self.config.extra.trigger = true
		end

		if context.after then
			self.config.extra.trigger = nil
		end
	end
})
