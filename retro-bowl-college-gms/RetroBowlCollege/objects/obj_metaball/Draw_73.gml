if (obj_controller.kicking) {
	exit;
}
draw_set_colour(16777215);
if (draw_arc) {
	for (b = 0; b < plot_len; b++) {
		draw_set_alpha(1);
		var z = plot_y[b] - plot_z[b];
		draw_sprite_ext(spr_aim, 0, plot_x[b], z, 2, 2, 0, 16777215, 1);
	}
}
