slog("Create obj_match_msg");
w = display_get_gui_width();
h = display_get_gui_height();
tx = w * 0.5;
ty = h * 0.5;
with (obj_controller) {
	if (state == 2) {
		other.ty = other.h * 0.75;
	}
}
