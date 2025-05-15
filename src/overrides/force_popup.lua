function Card:get_banned_force_popup_areas()
	return { G.pack_cards }
end

function Card:force_popup()
	if self.highlighted then
		if G.SETTINGS.paused and not self.area.config.collection then
			return false
		end

		if
			self.config.center.set == "Default"
			or self.config.center.set == "Base"
			or self.config.center.set == "Enhanced"
		then
			return false
		end

		if SMODS.Mods["incantation"] and self.area == G.consumeables then
			return false
		end

		for i, v in ipairs(self:get_banned_force_popup_areas()) do
			if self.area == v then
				return false
			end
		end

		return true
	end
end

local orig_cm = Card.move
function Card:move(dt)
	orig_cm(self, dt)
	if self.children.h_popup then
		self.children.h_popup.states.collide.can = true
		if not self:force_popup() and not self.states.hover.is then
			self.children.h_popup:remove()
			self.children.h_popup = nil
		end
	end
end
