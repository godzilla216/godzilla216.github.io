var new_pick = false;
if (global.gamepad) {
	if (global.gp.axisl_force > 0.2) {
		gp_mp += 0.12;
	} else {
		gp_mp -= 1;
	}
	gp_mp = clamp(gp_mp, 2, 7);
	if (abs(global.gp.axisl_h) > 0.2) {
		gp_x += global.gp.axisl_h * gp_mp;
	}
	if (abs(global.gp.axisl_v) > 0.2) {
		gp_y += global.gp.axisl_v * gp_mp;
	}
	gp_x = clamp(gp_x, 0, 480);
	gp_y = clamp(gp_y, 0, 270);
	if (gamepad_button_check_released(global.gp.slot, global.gp_select)) {
		new_pick = true;
	} else if (gamepad_button_check_released(global.gp.slot, global.gp_back)) {
		surface_free(surf);
		instance_destroy();
		s_msg_clear();
	}
} else if (s_is_touch_allowed()) {
	if (mouse_check_button_released(1)) {
		new_pick = true;
	}
}
if (new_pick) {
	if (global.gamepad) {
		obj_edit_team.new_col = surface_getpixel(surf, gp_x, gp_y);
	} else {
		obj_edit_team.new_col = surface_getpixel(surf, mouse_x, mouse_y);
	}
	if (obj_edit_team.new_col == 16738348) {
		obj_edit_team.new_col = -1;
	}
	surface_free(surf);
	instance_destroy();
	s_msg_clear();
}
