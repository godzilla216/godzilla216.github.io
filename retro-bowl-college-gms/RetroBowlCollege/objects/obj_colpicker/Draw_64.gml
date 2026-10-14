if (surface_exists(surf)) {
	draw_surface(surf, 0, 0);
	if (global.gamepad) {
		draw_sprite(spr_col_cursor, 0, gp_x, gp_y);
	}
} else {
	instance_destroy();
	s_msg_clear();
}
