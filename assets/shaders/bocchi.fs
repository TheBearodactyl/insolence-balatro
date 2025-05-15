#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

#define Q(X) ((float(X) / 255.0) * 2.0 - 1.0)
#define A(X) cos(X)
#define PI 3.14159265359

extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;
extern MY_HIGHP_OR_MEDIUMP vec2 bocchi;

vec3 f(vec2 x) {
	float a = A(x.x * Q(203) + x.y * Q(109) + 0.017204);
	float b = A(x.x * Q(60) + x.y * Q(246) + 0.304688);
	float c = A(x.x * Q(57) + x.y * Q(162) + -1.076767);
	float d = A(x.x * Q(238) + x.y * Q(-202) + 0.510483);
	float e = A(x.x * Q(134) + x.y * Q(-100) + -0.101097);
	float f = A(x.x * Q(127) + x.y * Q(127) + 0.000003);
	float g = A(x.x * Q(237) + x.y * Q(255) + -1.090445);
	float h = A(x.x * Q(223) + x.y * Q(139) + 1.573162);
	float i = A(x.x * Q(48) + x.y * Q(345) + 0.275851);
	float j = A(x.x * Q(164) + x.y * Q(123) + -0.085741);
	float k = A(x.x * Q(321) + x.y * Q(227) + -0.384445);
	float l = A(x.x * Q(30) + x.y * Q(194) + 1.957058);
	float m = A(x.x * Q(63) + x.y * Q(412) + 0.342708);
	float n = A(x.x * Q(128) + x.y * Q(128) + 0.000015);
	float o = A(x.x * Q(131) + x.y * Q(124) + -0.039112);
	float p = A(x.x * Q(-9) + x.y * Q(31) + -0.779752);
	float q = A(x.x * Q(-47) + x.y * Q(-93) + 0.906069);
	float r = A(x.x * Q(-48) + x.y * Q(123) + -0.320953);
	float s = A(x.x * Q(69) + x.y * Q(-2) + 0.427213);
	float t = A(x.x * Q(-68) + x.y * Q(120) + 0.039651);
	float u =
		A(a * Q(86) + b * Q(161) + c * Q(38) + d * Q(204) + e * Q(208) + f * Q(26) + g * Q(221) + h * Q(30) + i * Q(163) + j * Q(2) + k * Q(247) + l * Q(173) + m * Q(78)
		  + n * Q(16) + o * Q(-30) + p * Q(86) + q * Q(5) + r * Q(150) + s * Q(224) + t * Q(225) + -1.189891);
	float v =
		A(a * Q(110) + b * Q(207) + c * Q(154) + d * Q(119) + e * Q(-12) + f * Q(61) + g * Q(91) + h * Q(205) + i * Q(21) + j * Q(188) + k * Q(65) + l * Q(254) + m * Q(120)
		  + n * Q(183) + o * Q(256) + p * Q(145) + q * Q(261) + r * Q(182) + s * Q(38) + t * Q(87) + 0.264156);
	float w =
		A(a * Q(34) + b * Q(81) + c * Q(66) + d * Q(94) + e * Q(106) + f * Q(165) + g * Q(22) + h * Q(216) + i * Q(100) + j * Q(79) + k * Q(127) + l * Q(20) + m * Q(25)
		  + n * Q(180) + o * Q(145) + p * Q(94) + q * Q(144) + r * Q(61) + s * Q(80) + t * Q(178) + -0.115115);
	float y =
		A(a * Q(143) + b * Q(236) + c * Q(211) + d * Q(157) + e * Q(261) + f * Q(302) + g * Q(66) + h * Q(243) + i * Q(213) + j * Q(126) + k * Q(50) + l * Q(68) + m * Q(255)
		  + n * Q(295) + o * Q(193) + p * Q(95) + q * Q(142) + r * Q(117) + s * Q(45) + t * Q(75) + 0.154745);
	float z =
		A(a * Q(187) + b * Q(212) + c * Q(133) + d * Q(140) + e * Q(197) + f * Q(236) + g * Q(228) + h * Q(197) + i * Q(216) + j * Q(63) + k * Q(203) + l * Q(200) + m * Q(81)
		  + n * Q(207) + o * Q(127) + p * Q(173) + q * Q(139) + r * Q(139) + s * Q(214) + t * Q(82) + -0.238355);
	float aa =
		A(a * Q(185) + b * Q(126) + c * Q(243) + d * Q(16) + e * Q(41) + f * Q(265) + g * Q(93) + h * Q(165) + i * Q(99) + j * Q(202) + k * Q(29) + l * Q(77) + m * Q(149)
		  + n * Q(170) + o * Q(69) + p * Q(242) + q * Q(111) + r * Q(233) + s * Q(9) + t * Q(61) + 0.360677);
	float ab =
		A(a * Q(170) + b * Q(141) + c * Q(269) + d * Q(310) + e * Q(113) + f * Q(388) + g * Q(32) + h * Q(298) + i * Q(120) + j * Q(280) + k * Q(41) + l * Q(91) + m * Q(203)
		  + n * Q(399) + o * Q(222) + p * Q(246) + q * Q(21) + r * Q(177) + s * Q(74) + t * Q(61) + 1.621457);
	float ac =
		A(a * Q(166) + b * Q(187) + c * Q(183) + d * Q(175) + e * Q(182) + f * Q(245) + g * Q(130) + h * Q(187) + i * Q(48) + j * Q(189) + k * Q(193) + l * Q(52) + m * Q(98)
		  + n * Q(145) + o * Q(121) + p * Q(198) + q * Q(128) + r * Q(202) + s * Q(186) + t * Q(111) + 0.769090);
	float ad =
		A(a * Q(157) + b * Q(108) + c * Q(108) + d * Q(55) + e * Q(191) + f * Q(147) + g * Q(198) + h * Q(230) + i * Q(225) + j * Q(204) + k * Q(234) + l * Q(182) + m * Q(127)
		  + n * Q(231) + o * Q(257) + p * Q(235) + q * Q(30) + r * Q(109) + s * Q(30) + t * Q(146) + -0.223149);
	float ae =
		A(a * Q(71) + b * Q(179) + c * Q(140) + d * Q(62) + e * Q(138) + f * Q(221) + g * Q(-13) + h * Q(89) + i * Q(182) + j * Q(270) + k * Q(80) + l * Q(116) + m * Q(133)
		  + n * Q(105) + o * Q(276) + p * Q(176) + q * Q(58) + r * Q(196) + s * Q(175) + t * Q(249) + 0.073209);
	float af =
		A(a * Q(-40) + b * Q(26) + c * Q(107) + d * Q(165) + e * Q(161) + f * Q(22) + g * Q(183) + h * Q(113) + i * Q(128) + j * Q(-36) + k * Q(77) + l * Q(158) + m * Q(150)
		  + n * Q(-118) + o * Q(-29) + p * Q(44) + q * Q(207) + r * Q(-26) + s * Q(118) + t * Q(59) + -0.306009);
	float ag =
		A(a * Q(139) + b * Q(100) + c * Q(48) + d * Q(249) + e * Q(91) + f * Q(36) + g * Q(160) + h * Q(117) + i * Q(54) + j * Q(169) + k * Q(173) + l * Q(181) + m * Q(57)
		  + n * Q(67) + o * Q(94) + p * Q(148) + q * Q(146) + r * Q(150) + s * Q(129) + t * Q(197) + 0.187379);
	float ah =
		A(a * Q(200) + b * Q(192) + c * Q(95) + d * Q(4) + e * Q(44) + f * Q(154) + g * Q(7) + h * Q(77) + i * Q(119) + j * Q(232) + k * Q(86) + l * Q(75) + m * Q(124) + n * Q(218)
		  + o * Q(239) + p * Q(-10) + q * Q(100) + r * Q(155) + s * Q(-3) + t * Q(9) + 0.106646);
	float ai =
		A(a * Q(144) + b * Q(88) + c * Q(194) + d * Q(180) + e * Q(238) + f * Q(110) + g * Q(235) + h * Q(208) + i * Q(168) + j * Q(190) + k * Q(166) + l * Q(33) + m * Q(126)
		  + n * Q(94) + o * Q(129) + p * Q(-39) + q * Q(279) + r * Q(64) + s * Q(144) + t * Q(85) + 0.955852);
	float aj =
		A(a * Q(82) + b * Q(142) + c * Q(28) + d * Q(273) + e * Q(210) + f * Q(172) + g * Q(113) + h * Q(92) + i * Q(224) + j * Q(146) + k * Q(-105) + l * Q(207) + m * Q(195)
		  + n * Q(143) + o * Q(57) + p * Q(272) + q * Q(156) + r * Q(205) + s * Q(141) + t * Q(174) + 0.156471);
	float ak =
		A(a * Q(234) + b * Q(86) + c * Q(190) + d * Q(174) + e * Q(240) + f * Q(283) + g * Q(180) + h * Q(248) + i * Q(225) + j * Q(187) + k * Q(265) + l * Q(177) + m * Q(-13)
		  + n * Q(124) + o * Q(232) + p * Q(260) + q * Q(193) + r * Q(158) + s * Q(122) + t * Q(158) + 1.069778);
	float al =
		A(a * Q(233) + b * Q(215) + c * Q(138) + d * Q(96) + e * Q(137) + f * Q(166) + g * Q(258) + h * Q(211) + i * Q(4) + j * Q(284) + k * Q(266) + l * Q(87) + m * Q(114)
		  + n * Q(218) + o * Q(274) + p * Q(279) + q * Q(193) + r * Q(136) + s * Q(282) + t * Q(107) + 0.300485);
	float am =
		A(a * Q(26) + b * Q(133) + c * Q(168) + d * Q(111) + e * Q(23) + f * Q(111) + g * Q(192) + h * Q(105) + i * Q(62) + j * Q(102) + k * Q(-19) + l * Q(187) + m * Q(223)
		  + n * Q(152) + o * Q(93) + p * Q(153) + q * Q(-36) + r * Q(151) + s * Q(140) + t * Q(212) + -1.044700);
	float an =
		A(a * Q(189) + b * Q(184) + c * Q(105) + d * Q(195) + e * Q(193) + f * Q(232) + g * Q(69) + h * Q(77) + i * Q(291) + j * Q(15) + k * Q(150) + l * Q(126) + m * Q(128)
		  + n * Q(129) + o * Q(126) + p * Q(122) + q * Q(38) + r * Q(156) + s * Q(143) + t * Q(215) + 0.538356);
	float ao =
		A(a * Q(59) + b * Q(83) + c * Q(129) + d * Q(225) + e * Q(102) + f * Q(41) + g * Q(75) + h * Q(119) + i * Q(207) + j * Q(24) + k * Q(87) + l * Q(113) + m * Q(154)
		  + n * Q(-3) + o * Q(41) + p * Q(147) + q * Q(214) + r * Q(93) + s * Q(84) + t * Q(-3) + 0.247880);
	float ap =
		A(u * Q(70) + v * Q(91) + w * Q(77) + y * Q(194) + z * Q(53) + aa * Q(147) + ab * Q(16) + ac * Q(55) + ad * Q(83) + ae * Q(118) + af * Q(162) + ag * Q(92) + ah * Q(93)
		  + ai * Q(134) + aj * Q(169) + ak * Q(68) + al * Q(135) + am * Q(103) + an * Q(152) + ao * Q(173) + 0.377075);
	float aq =
		A(u * Q(168) + v * Q(-14) + w * Q(185) + y * Q(115) + z * Q(56) + aa * Q(147) + ab * Q(52) + ac * Q(164) + ad * Q(105) + ae * Q(250) + af * Q(24) + ag * Q(10) + ah * Q(117)
		  + ai * Q(119) + aj * Q(87) + ak * Q(65) + al * Q(154) + am * Q(94) + an * Q(219) + ao * Q(45) + -0.149401);
	float ar =
		A(u * Q(-25) + v * Q(82) + w * Q(-28) + y * Q(285) + z * Q(117) + aa * Q(206) + ab * Q(173) + ac * Q(185) + ad * Q(68) + ae * Q(169) + af * Q(216) + ag * Q(210)
		  + ah * Q(146) + ai * Q(26) + aj * Q(149) + ak * Q(85) + al * Q(214) + am * Q(69) + an * Q(130) + ao * Q(106) + 0.205749);
	float as =
		A(u * Q(225) + v * Q(202) + w * Q(157) + y * Q(180) + z * Q(7) + aa * Q(130) + ab * Q(169) + ac * Q(77) + ad * Q(185) + ae * Q(147) + af * Q(68) + ag * Q(238) + ah * Q(26)
		  + ai * Q(194) + aj * Q(101) + ak * Q(171) + al * Q(50) + am * Q(114) + an * Q(95) + ao * Q(99) + -0.242087);
	float at =
		A(u * Q(14) + v * Q(191) + w * Q(68) + y * Q(253) + z * Q(144) + aa * Q(51) + ab * Q(33) + ac * Q(226) + ad * Q(158) + ae * Q(177) + af * Q(169) + ag * Q(135) + ah * Q(76)
		  + ai * Q(191) + aj * Q(138) + ak * Q(145) + al * Q(224) + am * Q(227) + an * Q(55) + ao * Q(193) + 0.115651);
	float au =
		A(u * Q(129) + v * Q(79) + w * Q(121) + y * Q(135) + z * Q(131) + aa * Q(47) + ab * Q(-12) + ac * Q(21) + ad * Q(162) + ae * Q(129) + af * Q(131) + ag * Q(243)
		  + ah * Q(124) + ai * Q(-14) + aj * Q(76) + ak * Q(140) + al * Q(110) + am * Q(180) + an * Q(125) + ao * Q(37) + 0.342232);
	float av =
		A(u * Q(162) + v * Q(191) + w * Q(126) + y * Q(27) + z * Q(167) + aa * Q(45) + ab * Q(53) + ac * Q(137) + ad * Q(107) + ae * Q(-26) + af * Q(267) + ag * Q(288)
		  + ah * Q(203) + ai * Q(183) + aj * Q(9) + ak * Q(215) + al * Q(135) + am * Q(156) + an * Q(207) + ao * Q(229) + 0.893196);
	float aw =
		A(u * Q(125) + v * Q(224) + w * Q(42) + y * Q(54) + z * Q(92) + aa * Q(209) + ab * Q(121) + ac * Q(100) + ad * Q(156) + ae * Q(80) + af * Q(190) + ag * Q(256) + ah * Q(133)
		  + ai * Q(89) + aj * Q(103) + ak * Q(199) + al * Q(51) + am * Q(83) + an * Q(244) + ao * Q(208) + 0.126652);
	float ax =
		A(u * Q(135) + v * Q(126) + w * Q(152) + y * Q(78) + z * Q(124) + aa * Q(70) + ab * Q(98) + ac * Q(72) + ad * Q(196) + ae * Q(209) + af * Q(15) + ag * Q(8) + ah * Q(176)
		  + ai * Q(177) + aj * Q(88) + ak * Q(110) + al * Q(96) + am * Q(220) + an * Q(81) + ao * Q(96) + -0.411101);
	float ay =
		A(u * Q(87) + v * Q(103) + w * Q(124) + y * Q(187) + z * Q(34) + aa * Q(217) + ab * Q(146) + ac * Q(33) + ad * Q(-16) + ae * Q(197) + af * Q(129) + ag * Q(238)
		  + ah * Q(105) + ai * Q(228) + aj * Q(45) + ak * Q(154) + al * Q(24) + am * Q(51) + an * Q(42) + ao * Q(122) + 0.344390);
	float az =
		A(u * Q(-32) + v * Q(83) + w * Q(174) + y * Q(234) + z * Q(114) + aa * Q(134) + ab * Q(60) + ac * Q(207) + ad * Q(167) + ae * Q(167) + af * Q(119) + ag * Q(87) + ah * Q(55)
		  + ai * Q(51) + aj * Q(147) + ak * Q(62) + al * Q(255) + am * Q(114) + an * Q(204) + ao * Q(135) + -0.310499);
	float ba =
		A(u * Q(117) + v * Q(163) + w * Q(189) + y * Q(3) + z * Q(79) + aa * Q(85) + ab * Q(245) + ac * Q(182) + ad * Q(77) + ae * Q(19) + af * Q(130) + ag * Q(99) + ah * Q(190)
		  + ai * Q(89) + aj * Q(27) + ak * Q(182) + al * Q(155) + am * Q(144) + an * Q(18) + ao * Q(144) + -0.547381);
	float bb =
		A(u * Q(172) + v * Q(159) + w * Q(133) + y * Q(164) + z * Q(117) + aa * Q(74) + ab * Q(127) + ac * Q(182) + ad * Q(110) + ae * Q(169) + af * Q(95) + ag * Q(74)
		  + ah * Q(183) + ai * Q(88) + aj * Q(133) + ak * Q(79) + al * Q(67) + am * Q(66) + an * Q(28) + ao * Q(138) + -1.097930);
	float bc =
		A(u * Q(184) + v * Q(106) + w * Q(148) + y * Q(119) + z * Q(119) + aa * Q(123) + ab * Q(58) + ac * Q(231) + ad * Q(200) + ae * Q(133) + af * Q(184) + ag * Q(223)
		  + ah * Q(160) + ai * Q(80) + aj * Q(58) + ak * Q(234) + al * Q(199) + am * Q(149) + an * Q(173) + ao * Q(67) + 0.542699);
	float bd =
		A(u * Q(267) + v * Q(252) + w * Q(114) + y * Q(173) + z * Q(62) + aa * Q(166) + ab * Q(253) + ac * Q(224) + ad * Q(244) + ae * Q(113) + af * Q(6) + ag * Q(203) + ah * Q(93)
		  + ai * Q(169) + aj * Q(66) + ak * Q(189) + al * Q(179) + am * Q(141) + an * Q(104) + ao * Q(72) + -0.777262);
	float be =
		A(u * Q(18) + v * Q(143) + w * Q(168) + y * Q(39) + z * Q(284) + aa * Q(31) + ab * Q(136) + ac * Q(79) + ad * Q(94) + ae * Q(136) + af * Q(130) + ag * Q(95) + ah * Q(33)
		  + ai * Q(92) + aj * Q(188) + ak * Q(9) + al * Q(118) + am * Q(98) + an * Q(62) + ao * Q(174) + 0.850447);
	float bf =
		A(u * Q(233) + v * Q(116) + w * Q(-28) + y * Q(43) + z * Q(163) + aa * Q(199) + ab * Q(166) + ac * Q(135) + ad * Q(203) + ae * Q(227) + af * Q(-10) + ag * Q(35)
		  + ah * Q(157) + ai * Q(120) + aj * Q(121) + ak * Q(203) + al * Q(110) + am * Q(238) + an * Q(119) + ao * Q(249) + -1.454242);
	float bg =
		A(u * Q(31) + v * Q(14) + w * Q(128) + y * Q(208) + z * Q(231) + aa * Q(176) + ab * Q(21) + ac * Q(252) + ad * Q(293) + ae * Q(94) + af * Q(186) + ag * Q(112) + ah * Q(247)
		  + ai * Q(64) + aj * Q(168) + ak * Q(154) + al * Q(227) + am * Q(112) + an * Q(130) + ao * Q(-6) + -0.394833);
	float bh =
		A(u * Q(235) + v * Q(226) + w * Q(101) + y * Q(142) + z * Q(195) + aa * Q(158) + ab * Q(95) + ac * Q(207) + ad * Q(199) + ae * Q(202) + af * Q(176) + ag * Q(139)
		  + ah * Q(192) + ai * Q(61) + aj * Q(132) + ak * Q(93) + al * Q(90) + am * Q(48) + an * Q(169) + ao * Q(106) + 0.210249);
	float bi =
		A(u * Q(79) + v * Q(161) + w * Q(151) + y * Q(122) + z * Q(117) + aa * Q(77) + ab * Q(106) + ac * Q(106) + ad * Q(128) + ae * Q(104) + af * Q(163) + ag * Q(214)
		  + ah * Q(111) + ai * Q(23) + aj * Q(111) + ak * Q(147) + al * Q(187) + am * Q(136) + an * Q(130) + ao * Q(185) + -0.799511);
	float bj =
		A(ap * Q(60) + aq * Q(128) + ar * Q(36) + as * Q(152) + at * Q(12) + au * Q(210) + av * Q(33) + aw * Q(25) + ax * Q(186) + ay * Q(149) + az * Q(225) + ba * Q(129)
		  + bb * Q(215) + bc * Q(93) + bd * Q(-20) + be * Q(116) + bf * Q(20) + bg * Q(218) + bh * Q(156) + bi * Q(98) + 0.385517);
	float bk =
		A(ap * Q(139) + aq * Q(246) + ar * Q(57) + as * Q(151) + at * Q(63) + au * Q(18) + av * Q(16) + aw * Q(97) + ax * Q(236) + ay * Q(56) + az * Q(123) + ba * Q(151)
		  + bb * Q(100) + bc * Q(223) + bd * Q(60) + be * Q(133) + bf * Q(55) + bg * Q(99) + bh * Q(-31) + bi * Q(257) + 0.138722);
	float bl =
		A(ap * Q(200) + aq * Q(155) + ar * Q(203) + as * Q(-25) + at * Q(60) + au * Q(46) + av * Q(221) + aw * Q(242) + ax * Q(280) + ay * Q(-9) + az * Q(213) + ba * Q(-59)
		  + bb * Q(94) + bc * Q(46) + bd * Q(240) + be * Q(148) + bf * Q(285) + bg * Q(5) + bh * Q(365) + bi * Q(-83) + -0.495119);
	float bm =
		A(ap * Q(244) + aq * Q(188) + ar * Q(125) + as * Q(87) + at * Q(168) + au * Q(187) + av * Q(167) + aw * Q(-22) + ax * Q(116) + ay * Q(23) + az * Q(146) + ba * Q(91)
		  + bb * Q(222) + bc * Q(40) + bd * Q(158) + be * Q(129) + bf * Q(193) + bg * Q(203) + bh * Q(167) + bi * Q(-40) + 1.173156);
	float bn =
		A(ap * Q(-25) + aq * Q(128) + ar * Q(155) + as * Q(101) + at * Q(92) + au * Q(124) + av * Q(42) + aw * Q(-3) + ax * Q(107) + ay * Q(-8) + az * Q(262) + ba * Q(214)
		  + bb * Q(259) + bc * Q(149) + bd * Q(169) + be * Q(129) + bf * Q(188) + bg * Q(158) + bh * Q(120) + bi * Q(232) + -1.201857);
	float bo =
		A(ap * Q(163) + aq * Q(-25) + ar * Q(278) + as * Q(182) + at * Q(185) + au * Q(-26) + av * Q(262) + aw * Q(79) + ax * Q(248) + ay * Q(138) + az * Q(143) + ba * Q(216)
		  + bb * Q(2) + bc * Q(217) + bd * Q(10) + be * Q(55) + bf * Q(70) + bg * Q(136) + bh * Q(-43) + bi * Q(61) + 0.127087);
	float bp =
		A(ap * Q(127) + aq * Q(207) + ar * Q(115) + as * Q(132) + at * Q(210) + au * Q(-18) + av * Q(53) + aw * Q(150) + ax * Q(304) + ay * Q(175) + az * Q(225) + ba * Q(234)
		  + bb * Q(92) + bc * Q(237) + bd * Q(129) + be * Q(-46) + bf * Q(164) + bg * Q(-13) + bh * Q(22) + bi * Q(18) + 0.216627);
	float bq =
		A(ap * Q(86) + aq * Q(120) + ar * Q(129) + as * Q(156) + at * Q(112) + au * Q(129) + av * Q(116) + aw * Q(123) + ax * Q(120) + ay * Q(126) + az * Q(138) + ba * Q(163)
		  + bb * Q(71) + bc * Q(148) + bd * Q(126) + be * Q(140) + bf * Q(106) + bg * Q(136) + bh * Q(111) + bi * Q(183) + -0.123751);
	float br =
		A(ap * Q(225) + aq * Q(186) + ar * Q(34) + as * Q(169) + at * Q(247) + au * Q(156) + av * Q(208) + aw * Q(35) + ax * Q(11) + ay * Q(44) + az * Q(11) + ba * Q(157)
		  + bb * Q(86) + bc * Q(128) + bd * Q(83) + be * Q(95) + bf * Q(212) + bg * Q(219) + bh * Q(120) + bi * Q(94) + -0.405067);
	float bs =
		A(ap * Q(64) + aq * Q(68) + ar * Q(145) + as * Q(180) + at * Q(100) + au * Q(161) + av * Q(168) + aw * Q(132) + ax * Q(150) + ay * Q(132) + az * Q(173) + ba * Q(146)
		  + bb * Q(172) + bc * Q(96) + bd * Q(35) + be * Q(192) + bf * Q(75) + bg * Q(132) + bh * Q(-51) + bi * Q(168) + 0.608800);
	float bt =
		A(ap * Q(216) + aq * Q(242) + ar * Q(101) + as * Q(96) + at * Q(191) + au * Q(201) + av * Q(170) + aw * Q(157) + ax * Q(28) + ay * Q(143) + az * Q(158) + ba * Q(109)
		  + bb * Q(231) + bc * Q(165) + bd * Q(96) + be * Q(133) + bf * Q(-18) + bg * Q(175) + bh * Q(224) + bi * Q(99) + 0.015621);
	float bu =
		A(ap * Q(251) + aq * Q(147) + ar * Q(84) + as * Q(39) + at * Q(139) + au * Q(153) + av * Q(130) + aw * Q(104) + ax * Q(108) + ay * Q(150) + az * Q(108) + ba * Q(63)
		  + bb * Q(125) + bc * Q(247) + bd * Q(200) + be * Q(140) + bf * Q(54) + bg * Q(163) + bh * Q(139) + bi * Q(171) + 1.008106);
	float bv =
		A(ap * Q(145) + aq * Q(183) + ar * Q(178) + as * Q(103) + at * Q(231) + au * Q(252) + av * Q(227) + aw * Q(222) + ax * Q(103) + ay * Q(212) + az * Q(32) + ba * Q(77)
		  + bb * Q(231) + bc * Q(79) + bd * Q(144) + be * Q(242) + bf * Q(108) + bg * Q(56) + bh * Q(53) + bi * Q(102) + -0.475757);
	float bw =
		A(ap * Q(108) + aq * Q(165) + ar * Q(153) + as * Q(155) + at * Q(193) + au * Q(209) + av * Q(106) + aw * Q(66) + ax * Q(139) + ay * Q(123) + az * Q(166) + ba * Q(141)
		  + bb * Q(155) + bc * Q(0) + bd * Q(124) + be * Q(205) + bf * Q(160) + bg * Q(126) + bh * Q(126) + bi * Q(-20) + 0.456243);
	float bx =
		A(ap * Q(248) + aq * Q(149) + ar * Q(137) + as * Q(81) + at * Q(105) + au * Q(82) + av * Q(129) + aw * Q(110) + ax * Q(152) + ay * Q(114) + az * Q(155) + ba * Q(79)
		  + bb * Q(229) + bc * Q(32) + bd * Q(248) + be * Q(20) + bf * Q(135) + bg * Q(167) + bh * Q(147) + bi * Q(42) + 0.500912);
	float by =
		A(ap * Q(155) + aq * Q(161) + ar * Q(300) + as * Q(118) + at * Q(45) + au * Q(270) + av * Q(-52) + aw * Q(65) + ax * Q(294) + ay * Q(83) + az * Q(116) + ba * Q(145)
		  + bb * Q(105) + bc * Q(127) + bd * Q(243) + be * Q(73) + bf * Q(80) + bg * Q(79) + bh * Q(41) + bi * Q(151) + 0.648712);
	float bz =
		A(ap * Q(128) + aq * Q(203) + ar * Q(122) + as * Q(99) + at * Q(-5) + au * Q(34) + av * Q(20) + aw * Q(122) + ax * Q(288) + ay * Q(58) + az * Q(201) + ba * Q(113)
		  + bb * Q(205) + bc * Q(173) + bd * Q(157) + be * Q(100) + bf * Q(98) + bg * Q(61) + bh * Q(11) + bi * Q(151) + 0.800142);
	float ca =
		A(ap * Q(68) + aq * Q(151) + ar * Q(164) + as * Q(-110) + at * Q(145) + au * Q(-5) + av * Q(91) + aw * Q(200) + ax * Q(120) + ay * Q(265) + az * Q(105) + ba * Q(188)
		  + bb * Q(14) + bc * Q(121) + bd * Q(200) + be * Q(61) + bf * Q(76) + bg * Q(148) + bh * Q(240) + bi * Q(8) + -0.050848);
	float cb =
		A(ap * Q(108) + aq * Q(159) + ar * Q(73) + as * Q(206) + at * Q(46) + au * Q(234) + av * Q(87) + aw * Q(41) + ax * Q(-27) + ay * Q(63) + az * Q(191) + ba * Q(-15)
		  + bb * Q(204) + bc * Q(217) + bd * Q(156) + be * Q(194) + bf * Q(126) + bg * Q(250) + bh * Q(273) + bi * Q(265) + 0.301596);
	float cc =
		A(ap * Q(107) + aq * Q(95) + ar * Q(129) + as * Q(146) + at * Q(123) + au * Q(61) + av * Q(141) + aw * Q(186) + ax * Q(118) + ay * Q(188) + az * Q(126) + ba * Q(108)
		  + bb * Q(154) + bc * Q(67) + bd * Q(168) + be * Q(116) + bf * Q(100) + bg * Q(94) + bh * Q(166) + bi * Q(154) + -0.785413);
	float cd = -0.046465 + bj * Q(122) + bk * Q(149) + bl * Q(114) + bm * Q(102) + bn * Q(134) + bo * Q(121) + bp * Q(122) + bq * Q(186) + br * Q(149) + bs * Q(118) + bt * Q(130)
		+ bu * Q(117) + bv * Q(116) + bw * Q(147) + bx * Q(155) + by * Q(118) + bz * Q(101) + ca * Q(136) + cb * Q(121) + cc * Q(165);
	float ce = 0.314208 + bj * Q(119) + bk * Q(150) + bl * Q(114) + bm * Q(103) + bn * Q(140) + bo * Q(119) + bp * Q(120) + bq * Q(95) + br * Q(149) + bs * Q(131) + bt * Q(122)
		+ bu * Q(102) + bv * Q(118) + bw * Q(157) + bx * Q(153) + by * Q(119) + bz * Q(104) + ca * Q(135) + cb * Q(116) + cc * Q(154);
	float cf = 0.475894 + bj * Q(120) + bk * Q(151) + bl * Q(115) + bm * Q(107) + bn * Q(140) + bo * Q(120) + bp * Q(120) + bq * Q(88) + br * Q(149) + bs * Q(125) + bt * Q(124)
		+ bu * Q(109) + bv * Q(119) + bw * Q(152) + bx * Q(153) + by * Q(119) + bz * Q(103) + ca * Q(136) + cb * Q(119) + cc * Q(150);
	return vec3(cd, ce, cf);
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv) {
	if (dissolve < 0.001) {
		return vec4(shadow ? vec3(0., 0., 0.) : tex.xyz, shadow ? tex.a * 0.3 : tex.a);
	}

	float adjusted_dissolve = (dissolve * dissolve * (3. - 2 * dissolve)) * 1.02 - 0.01;
	float t = time * 10.0 * 2003.;
	vec2 floored_uv = (floor((uv * texture_details.ba))) / max(texture_details.b, texture_details.a);
	vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);

	vec2 field_part1 = uv_scaled_centered + 50. * vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50. * vec2(cos(t / 53.1532), cos(t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50. * vec2(sin(-t / 87.53218), sin(-t / 49.0000));

	float field =
		(1. * (cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) + cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92)))
		/ 2.;
	vec2 borders = vec2(0.2, 0.8);

	float res = (.5 * .5 * cos((adjusted_dissolve) / 82.612 + (field + -.5) * 3.14))
		- (floored_uv.x > borders.y ? (floored_uv.x - borders.y) * (5. + 5. * dissolve) : 0.) * (dissolve)
		- (floored_uv.y > borders.y ? (floored_uv.y - borders.y) * (5. + 5. * dissolve) : 0.) * (dissolve)
		- (floored_uv.x < borders.x ? (borders.x - floored_uv.x) * (5. + 5. * dissolve) : 0.) * (dissolve)
		- (floored_uv.y < borders.x ? (borders.x - floored_uv.y) * (5. + 5. * dissolve) : 0.) * (dissolve);

	if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
		if (!shadow && res < adjusted_dissolve + 0.5 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
			tex.rgba = burn_colour_1.rgba;
		} else if (burn_colour_2.a > 0.01) {
			tex.rgba = burn_colour_2.rgba;
		}
	}

	return vec4(shadow ? vec3(0., 0., 0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a * 0.3 : tex.a) : .0);
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.ba) / texture_details.ba;

	float x = mix(-PI, PI, uv.x);
	float y = mix(-PI, PI, 1.0 - uv.y);
	float scale = 1.0 + 1.125 * (cos(time - clamp(bocchi.y, 0.000001, 0.000001)) + 1.0);
	vec3 color = f(vec2(y * scale, x * scale));
	vec4 final_color = vec4(color, 0.75);

	return dissolve_mask(tex * final_color, texture_coords, uv);
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
	if (hovering <= 0.) {
		return transform_projection * vertex_position;
	}
	float mid_dist = length(vertex_position.xy - 0.5 * love_ScreenSize.xy) / length(love_ScreenSize.xy);
	vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy) / screen_scale;
	float scale = 0.2 * (-0.03 - 0.3 * max(0., 0.3 - mid_dist)) * hovering * (length(mouse_offset) * length(mouse_offset)) / (2. - mid_dist);

	return transform_projection * vertex_position + vec4(0, 0, 0, scale);
}
#endif

// void mainImage(out vec4 fragColor, in vec2 fragCoord) {
//     vec2 uv = fragCoord / iResolution.xy;

//     float x = mix(-PI, PI, uv.x);
//     float y = mix(-PI, PI, 1. - uv.y);
//     float scale = 1.0 + 1.125 * (sin(iTime) + 1.0);
//     vec3 color = f(vec2(x * scale, y * scale));
//     fragColor = vec4(color, 1.0);
// }