local debug_plus_api = require("debugplus-api")

if not (debug_plus_api and debug_plus_api.isVersionCompatible(1)) then
	return
end

local debugplus = debug_plus_api.registerID("Insolence") or {}

debugplus.addCommand({
	name = "reverse",
	shortDesc = "Reverse a Joker",
	desc = "Reverses the values of the hovered Joker",
	exec = function(args, raw_args, dbp)
		for k, v in pairs(dbp.hovered.ability) do
			if type(v) == "number" then
				dbp.hovered.ability[k] = -v
			end
		end

		return "Reversed all values of " .. dbp.hovered.config.center.name
	end,
})
