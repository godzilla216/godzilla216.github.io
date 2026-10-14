if (s_is_co_mode()) {
	exit;
}
if (is_undefined(text)) {
	exit;
}
var w = sprite_width;
var h = sprite_height;
draw_sprite(spr_box, 0, x, y);
draw_sprite_ext(spr_box, 2, x + 4, y, (sprite_width - 8) / 4, 1, 0, 16777215, 1);
draw_sprite(spr_box, 1, x + w - 4, y);
draw_sprite_ext(spr_box, 3, x + w - 2, y + 4, 1, (sprite_height - 8) / 4, 0, 16777215, 1);
draw_sprite(spr_box, 0, x + w - 4, y + h - 4);
draw_sprite_ext(spr_box, 2, x + 4, y + h - 2, (sprite_width - 8) / 4, 1, 0, 16777215, 1);
draw_sprite(spr_box, 1, x, y + h - 4);
draw_sprite_ext(spr_box, 3, x, y + 4, 1, (sprite_height - 8) / 4, 0, 16777215, 1);
draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var title = string_upper(text);
var tx = x;
var ty = y;
var sw = 1 + string_hd_width(title) / 2;
var sh = 1 + string_hd_height(title) / 2;
tx += sprite_width / 2;
if (title != "") {
	draw_rectangle_color(tx - sw - 1, ty - sh - 1, tx + sw, ty + sh, global.c_background, global.c_background, global.c_background, global.c_background, 0);
	draw_hd_text(tx, ty, title);
}
var txt = string_upper(s_str("ui_DivisionLeaders"));
var th = string_hd_height(txt);
if (!playoff12) {
	th -= 1;
}
tx = x + 12;
tx2 = x + sprite_width - 60;
ty += th;
draw_set_halign(0);
draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
draw_hd_text(tx, ty, txt);
ty += th;
for (var i = 0; i < 4; i++) {
	draw_set_halign(0);
	txt = ds_list_find_value(seedlist, i);
	if (string_count("yel_", txt)) {
		draw_hd_text_color(tx + 4, ty, string_replace(txt, "yel_", ""), global.c_primary, global.c_primary, global.c_primary, global.c_primary, 1);
	} else {
		draw_hd_text(tx + 4, ty, txt);
	}
	draw_set_halign(1);
	txt = ds_list_find_value(list_w, i);
	draw_hd_text(tx2, ty, txt);
	txt = ds_list_find_value(list_l, i);
	draw_hd_text(tx2 + 20, ty, txt);
	txt = ds_list_find_value(list_t, i);
	draw_hd_text(tx2 + 40, ty, txt);
	ty += th;
}
if (!playoff12) {
	ty += 1;
}
draw_set_halign(0);
txt = string_upper(s_str("ui_WildCard"));
draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
draw_hd_text(tx, ty, txt);
ty += th;
for (var i = 4; i < 4 + wildcards; i++) {
	draw_set_halign(0);
	txt = ds_list_find_value(seedlist, i);
	if (string_count("yel_", txt)) {
		draw_hd_text_color(tx + 4, ty, string_replace(txt, "yel_", ""), global.c_primary, global.c_primary, global.c_primary, global.c_primary, 1);
	} else {
		draw_hd_text(tx + 4, ty, txt);
	}
	draw_set_halign(1);
	txt = ds_list_find_value(list_w, i);
	draw_hd_text(tx2, ty, txt);
	txt = ds_list_find_value(list_l, i);
	draw_hd_text(tx2 + 20, ty, txt);
	txt = ds_list_find_value(list_t, i);
	draw_hd_text(tx2 + 40, ty, txt);
	ty += th;
}
if (!playoff12) {
	ty += 1;
}
draw_set_halign(0);
txt = string_upper(s_str("ui_InTheHunt"));
draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
draw_hd_text(tx, ty, txt);
ty += th;
for (var i = 4 + wildcards; i < ds_list_size(seedlist); i++) {
	draw_set_halign(0);
	txt = ds_list_find_value(seedlist, i);
	if (string_count("yel_", txt)) {
		draw_hd_text_color(tx + 4, ty, string_replace(txt, "yel_", ""), global.c_primary, global.c_primary, global.c_primary, global.c_primary, 1);
	} else {
		draw_hd_text(tx + 4, ty, txt);
	}
	draw_set_halign(1);
	txt = ds_list_find_value(list_w, i);
	draw_hd_text(tx2, ty, txt);
	txt = ds_list_find_value(list_l, i);
	draw_hd_text(tx2 + 20, ty, txt);
	txt = ds_list_find_value(list_t, i);
	draw_hd_text(tx2 + 40, ty, txt);
	ty += th;
	if (ty > y + (sprite_height - 8)) {
		break;
	}
}
