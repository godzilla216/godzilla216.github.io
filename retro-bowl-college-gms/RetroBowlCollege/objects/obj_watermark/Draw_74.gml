var tx = display_get_gui_width() * 0.5;
var ty = display_get_gui_height() * 0.5;
draw_sprite_ext(spr_watermark, 0, tx, ty, sclx, scly, rot, col, 1);
draw_set_font(global.fnt_restart_flex);
draw_set_halign(0);
draw_set_alpha(0.6);
switch (page) {
	case 1:
		draw_hd_text_ext(display_get_gui_width() * 0.01, ty + 8, msg1, 12, 389);
		if (s_is_co_mode()) {
			draw_hd_text_ext(display_get_gui_width() * 0.15, ty + 8, msg2, 12, 389);
		} else {
			draw_hd_text_ext(display_get_gui_width() * 0.5, ty + 8, msg2, 12, 389);
		}
		break;
	case 2:
		draw_hd_text_ext(display_get_gui_width() * 0.17, ty + 8, msg4, 12, 389);
		draw_set_halign(2);
		draw_hd_text_ext(display_get_gui_width() * 0.16, ty + 8, msg3, 12, 389);
		break;
	case 3:
		draw_hd_text_ext(display_get_gui_width() * 0.01, ty + 8, msg5, 12, 389);
		draw_hd_text_ext(display_get_gui_width() * 0.5, ty + 8, msg6, 12, 389);
		break;
}
draw_set_alpha(1);
