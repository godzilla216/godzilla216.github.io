function s_draw_scrimmage() {
	if (s_is_kickoff(true)) {
		return;
	}
	var chains = spr_chains_noout;
	draw_set_alpha(0.6);
	draw_line_width_colour(x_scrim, 131, x_scrim, 470, 2, 16711680, 16711680);
	if (yards >= 1) {
		draw_sprite_ext(chains, 1, x_scrim, 126, 2, 2, 0, 16777215, 1);
	}
	if (x_yards > 300 && x_yards < 2300) {
		draw_line_width_colour(x_yards, 131, x_yards, 470, 2, 65535, 65535);
		draw_sprite_ext(chains, 0, x_yards, 126, 2, 2, 0, 16777215, 1);
	}
	draw_set_alpha(1);
}

