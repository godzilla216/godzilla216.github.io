draw_set_font(global.fnt_small_flex);
draw_set_halign(0);
var tx = x + 8;
var ty = y + 12;
var bounds_y1 = ty;
var bounds_y2 = ty + sprite_height - 16;
ty += yoffset;
with (obj_master) {
	for (var i = 0; i < ds_list_size(other.ach_list); i++) {
		if (ty >= bounds_y1 && ty <= bounds_y2) {
			var ach = ds_list_find_value(other.ach_list, i);
			if (ds_exists(ach, 1)) {
				if (s_achievement_is_valid(ach) == false) {
					continue;
				}
				if (is_undefined(ds_map_find_value(ach, "achieved"))) {
					ds_map_set(ach, "achieved", 0);
				}
				if (is_undefined(ds_map_find_value(ach, "description"))) {
					ds_map_set(ach, "description", "Achievement " + string(i + 1));
				}
				var txt = ds_map_find_value(ach, "description");
				var col = 16777215;
				var alf = 0.35;
				if (real(ds_map_find_value(ach, "achieved")) > 0) {
					alf = 1;
				}
				draw_hd_text_color(tx, ty, txt, col, col, col, col, alf);
			} else {
				continue;
			}
		}
		ty += other.txt_h;
	}
}
draw_rectangle_color(x, y + sprite_height, x + sprite_width, y + sprite_height + 2, global.c_background, global.c_background, global.c_background, global.c_background, 0);
event_inherited();
if (yoffset < 0) {
	draw_sprite_ext(spr_arrowL2, 0, x + sprite_width - 10, y + 12, 0.5, 0.5, -90, 16777215, 1);
}
if (yoffset > clampsize + 10) {
	draw_sprite_ext(spr_arrowL2, 0, x + sprite_width - 10, y + sprite_height - 12, 0.5, 0.5, 90, 16777215, 1);
}
