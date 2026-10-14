draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var tx = x;
var ty = y + 12;
var bounds_y1 = ty;
var bounds_y2 = ty + sprite_height - 16;
ty += yoffset;
for (var i = 0; i < ds_list_size(reclist_a); i++) {
	if (ty >= bounds_y1 && ty <= bounds_y2) {
		tx = x + 10;
		draw_set_halign(0);
		draw_hd_text(tx, ty, ds_list_find_value(reclist_a, i));
		tx = x + sprite_width - 18;
		draw_set_halign(2);
		draw_hd_text(tx, ty, ds_list_find_value(reclist_b, i));
	}
	ty += txt_h;
}
draw_rectangle_color(x, y + sprite_height, x + sprite_width, y + sprite_height + 2, global.c_background, global.c_background, global.c_background, global.c_background, 0);
event_inherited();
if (yoffset < 0) {
	draw_sprite_ext(spr_arrowL2, 0, x + sprite_width - 10, y + 12, 0.5, 0.5, -90, 16777215, 1);
}
if (yoffset > clampsize + 10) {
	draw_sprite_ext(spr_arrowL2, 0, x + sprite_width - 10, y + sprite_height - 12, 0.5, 0.5, 90, 16777215, 1);
}
