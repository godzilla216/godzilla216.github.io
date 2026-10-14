if (!visible) {
	exit;
}
switch (step) {
	case 0:
		if (x + y == 0) {
			draw_set_font(global.fnt_small_flex);
			var txtw = string_hd_width_ext(text, -1, msg_width);
			var titlew = string_hd_width_ext(title, -1, msg_width);
			if (titlew > txtw) {
				txtw = titlew;
			}
			x = 22 + txtw * 0.5;
			y = display_get_gui_height();
		}
		y -= 2;
		if (y < display_get_gui_height() - 2 - string_hd_height_ext(text, -1, msg_width)) {
			alarm[0] = delay;
			step++;
		}
		break;
	case 1:
		break;
	case 2:
		y += 4;
		if (y > display_get_gui_height() + 32) {
			with (obj_master) {
				ds_list_delete(list_notifications, 0);
				var sz = ds_list_size(list_notifications);
				if (sz > 0) {
					slog("Notifications remaining = " + string(sz));
					var ntf = ds_list_find_value(list_notifications, 0);
					ntf.visible = true;
				}
			}
			instance_destroy();
		}
		break;
}
