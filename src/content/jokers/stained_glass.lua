SMODS.Shader({
	key = "stained",
	path = "stained.fs",
})

G.FUNCS.go_to_stained_glass_shader = function(e)
	love.system.openURL("https://shadertoy.com/view/wsfXDS")
end

SMODS.Joker({
	key = "stained_glass",
	atlas = "jokers",
	discovered = false,
	unlocked = false,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,
	pos = { x = 3, y = 1 },
	loc_txt = {
		["en-us"] = {
			name = "Stained Glass",
			text = {
				"{C:attention}Glass will not break{}",
				" ",
				"Shader: https://shadertoy.com/view/wsfXDS",
			},
			unlock = {
				"{C:attention}Shatter{} at least {C:attention}5{}",
				"{C:attention}Glass{} Cards in a single {C:attention}hand{}",
			},
		},
		["ja"] = {
			name = "ステンドグラス",
			text = {
				"{C:attention}ガラスは割れません{}",
				" ",
				"Shader: https://shadertoy.com/view/wsxXDS",
			},
			unlock = {
				"{C:attention}少なくとも{}5{}枚のガラスカードを片手で割る{}",
				"{C:attention}ガラスカードを集める {}",
			},
		},
		["ko"] = {
			name = "색유리",
			text = {
				"{C:attention}유리는 깨지지 않습니다{}{}",
				" ",
				"Shader : https://shadertoy.com/view/wsxXDS",
			},
			unlock = {
				"{C:attention}손에 {}5{}장 이상의 유리 카드를 부수기{}",
				"{C:attention}유리 카드 수집하기{}",
			},
		},
		["nl"] = {
			name = "Gezeteld glas",
			text = {
				"{C:attention}Glas zal niet breken{}",
				" ",
				"Shader: https://shadertoy.com/view/wsgetXDS",
			},
			unlock = {
				"{C:attention}Breek {} at least {}5{} glasplaten in één hand{}",
				"{C:attention}Glas{}-kaarten verzamelen!",
			},
		},
		["zh_cn"] = {
			name = "彩绘玻璃",
			text = {
				"{C:attention}玻璃不会碎{}",
				" ",
				"Shader : https://shadertoy.com/view/wsxXDS",
			},
			unlock = {
				"{C:attention}用一只手打破至少 {}5{} 张玻璃卡{}",
				"{C:attention}收集玻璃卡 {}",
			},
		},
		["zh_TW"] = {
			name = "彩繪玻璃",
			text = {
				"{C:attention}玻璃不會碎{}",
				" ",
				"Shader: https://shadertoy.com/view/wsxXDS",
			},
			unlock = {
				"{C:attention}用一隻手打破至少{} {C:attention}5{} 張玻璃牌,",
				"{C:attention}收集玻璃牌。",
			},
		},
		["ru"] = {
			name = "Плетёное стекло",
			text = {
				"{C:attention}Стекло не разбится{}",
				" ",
				"Шейдер: https://shadertoy.com/view/wsxXDS",
			},
			unlock = {
				"{C:attention}Разбить как минимум {}5{} стеклянных карт одной рукой{}",
				"{C:attention}Соберите стеклянные карты {}",
			},
		},
		["id"] = {
			name = "Kaca Pecah",
			text = {
				"{C:attention}Kaca tidak akan pecah{}",
				" ",
				"Shader: https://shadertoy.com/view/wsxXDS",
			},
			unlock = {
				"{C:attention}Pecahkan setidaknya {}5{} kartu kaca dalam satu tangan{}",
				"{C:attention}Kumpulkan kartu kaca{}",
			},
		},
		["it"] = {
			name = "Vetro Colorato",
			text = {
				"{C:attention}Il vetro non si romperà{}",
				" ",
				"Shader: https://shadertoy.com/view/wsxXDS",
			},
			unlock = {
				"{C:attention}Rompere almeno {}5{} carte di vetro con una mano{}",
				"{C:attention}Raccogliere carte di vetro {}",
			},
		},
		["pl"] = {
			name = "Wyrzeźbione szkło",
			text = {
				"{C:attention}Szkło nie pęknie{}",
				" ",
				"Shader: https://shadertoy.com/view/wsxXDS",
			},
			unlock = {
				"{C:attention}Zniszcz co najmniej {}5{} kart szklanych w jednej ręce{}",
				"{C:attention} Zbierz karty szklane",
			},
		},
		["pt_BR"] = {
			name = "Vidro Esmaltado",
			text = {
				"{C:attention}O vidro não vai rachar{}",
				" ",
				"Shader: https://shadertoy.com/view/wsxXDS",
			},
			unlock = {
				"{C:attention}Quebre no mínimo {}5{} cartas de vidro com uma mão{}",
				"{C:attention}Colete cartas de vidro {}",
			},
		},
		["fr"] = {
			name = "Verre teinté",
			text = {
				"{C:attention}Le verre ne se brisera pas{}",
				" ",
				"Shader : https://shadertoy.com/view/wsxXDS",
			},
			unlock = {
				"{C:attention}Briser {} au moins {}5{} cartes de verre dans une même main{}",
				"{C:attention}Collecter des cartes de verre{}",
			},
		},

	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["m_bearo_unoriginal_art"]
	end,
	check_for_unlock = function(self, args)
		if args.type == "shatter" then
			if #args.shattered >= 5 then
				return true
			end
		end
	end,
	draw = function(self, card, layer)
		if card.config.center.discovered or card.bypass_discovery_center then
			card.children.center:draw_shader("bearo_stained", nil, card.ARGS.send_to_shader)
		end
	end,
})

SMODS.Enhancement:take_ownership("glass", {
	calculate = function(self, card, context)
		if
			(
				context.destroy_card
				and context.cardarea == G.play
				and context.destroy_card == card
				and pseudorandom("glass") < G.GAME.probabilities.normal / card.ability.extra
			) and not ((BEARO.UTILS.count_num_of_joker_bearo("stained_glass") >= 1) == true)
		then
			return {
				remove = true,
			}
		end
	end,
})
