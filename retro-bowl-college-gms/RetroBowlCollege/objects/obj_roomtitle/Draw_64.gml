var frame_img = spr_spangle;
var draw_for_co = false;
if (s_is_co_mode()) {
	frame_img = spr_co_shield;
	draw_for_co = true;
}
draw_set_font(global.fnt_flex);
draw_set_halign(1);
draw_set_valign(1);
var txt = string_upper(text);
var tx = display_get_gui_width() * 0.5;
var tw = string_hd_width(txt) * 0.5 + sprite_get_width(frame_img) + 16;
draw_hd_text(tx, ty, txt);
if (show_stars && (string_hd_width(txt) < display_get_gui_width() * 0.5 || room == rm_master)) {
	if (draw_for_co == false) {
		draw_sprite_ext(frame_img, 0, tx - tw, ty, 2, 2, 0, 16777215, 1);
		draw_sprite_ext(frame_img, 0, tx + tw - 2, ty, -2, 2, 0, 16777215, 1);
	} else {
		var scl = 1;
		draw_sprite_ext(frame_img, 0, tx - tw, ty - 6, scl, scl, 0, 16777215, 1);
		draw_sprite_ext(frame_img, 0, tx + tw - 2, ty - 6, scl, scl, 0, 16777215, 1);
	}
}
