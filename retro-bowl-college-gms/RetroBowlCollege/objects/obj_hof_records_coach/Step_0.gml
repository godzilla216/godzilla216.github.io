if (global.gamepad && global.gp.ui_selected == id && active) {
	if (global.gp.triggerl) {
		flick_lineY += 0.5;
	} else if (global.gp.triggerr) {
		flick_lineY -= 0.5;
	} else {
		flick_lineY -= global.gp.axisr_v * 0.5;
	}
}
if (abs(flick_lineY)) {
	yoffset += flick_lineY;
}
if (s_is_touch_allowed() && mouse_check_button(1) && mouse_x > x && mouse_x < x + sprite_width && mouse_y > y && mouse_y < y + sprite_height) {
	if (ms_offset == 0) {
		ms_offset = yoffset - mouse_y;
	}
	yoffset = ms_offset + mouse_y;
	flick_lineY = 0;
} else {
	ms_offset = 0;
}
flick_lineY *= 0.9;
clampsize = -(listsize + 1) * txt_h + sprite_height;
yoffset = clamp(yoffset, clampsize, 0);
