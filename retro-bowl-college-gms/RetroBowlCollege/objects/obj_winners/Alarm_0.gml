if (has_fireworks) {
	effect_create_above(3, random(g_pBuiltIn.room_width), random(g_pBuiltIn.room_height) - 100, choose(0, 1, 2), make_colour_hsv(random(255), 255, 255));
	alarm[0] = random(firework_rate) + 1;
}
