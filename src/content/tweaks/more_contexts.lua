--- @diagnostic disable: duplicate-set-field, lowercase-global

-- Clicked left mouse button
local lcpref = Controller.L_cursor_press
function Controller:L_cursor_press(x, y)
	lcpref(self, x, y)
	if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
		SMODS.calculate_context({ bearo_clicked_left = true })
	end
end

-- Released left mouse button
local lcrref = Controller.L_cursor_release
function Controller:L_cursor_release(x, y)
	lcrref(self, x, y)
	if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
		SMODS.calculate_context({ bearo_released_left = true })
	end
end

-- Modified amount of money
local edref = ease_dollars
function ease_dollars(mod, instant)
	edref(mod, instant)
	if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
		SMODS.calculate_context({ bearo_eased_dollars = true })
	end
end

-- Modified amount of chips
local ecref = ease_chips
function ease_chips(mod)
	ecref(mod)
	if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
		SMODS.calculate_context({ bearo_eased_chips = true })
	end
end
