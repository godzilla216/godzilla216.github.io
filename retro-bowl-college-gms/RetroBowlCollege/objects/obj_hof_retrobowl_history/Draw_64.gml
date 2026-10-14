draw_set_font(global.fnt_small_flex);
draw_set_halign(0);
var tx = x + 8;
var ty = y + 12;
var bounds_y1 = ty;
var bounds_y2 = ty + sprite_height - 16;
ty += yoffset;
for (var i = ds_list_size(retrobowlhistory) - 1; i > -1; i--) {
	if (ty >= bounds_y1 && ty <= bounds_y2) {
		var map = ds_list_find_value(retrobowlhistory, i);
		var year = real(ds_map_find_value(map, "year"));
		var bowlnum = year - 1966;
		var winner = ds_map_find_value(map, "winner");
		var scr = ds_map_find_value(map, "score");
		var loser = scr + " " + ds_map_find_value(map, "loser");
		var human = real(ds_map_find_value(map, "human"));
		var col = 16777215;
		switch (human) {
			case 1:
				col = global.c_primary;
				break;
			case -1:
				col = 12632256;
				break;
		}
		var a = 1;
		if (year <= 2021) {
			a = 0.5;
		}
		tx = x + 8;
		draw_set_halign(0);
		draw_hd_text_color(tx, ty, s_roman_numerals(bowlnum), col, col, col, col, a);
		draw_set_halign(0);
		draw_hd_text_color(tx + 52, ty, winner, col, col, col, col, a);
		tx = x + sprite_width - 18;
		draw_set_halign(2);
		draw_hd_text_color(tx, ty, loser, col, col, col, col, a);
	}
	ty += other.txt_h;
}
draw_rectangle_color(x, y + sprite_height, x + sprite_width, y + sprite_height + 2, global.c_background, global.c_background, global.c_background, global.c_background, 0);
event_inherited();
if (yoffset < 0) {
	draw_sprite_ext(spr_arrowL2, 0, x + sprite_width - 10, y + 12, 0.5, 0.5, -90, 16777215, 1);
}
if (yoffset > clampsize + 10) {
	draw_sprite_ext(spr_arrowL2, 0, x + sprite_width - 10, y + sprite_height - 12, 0.5, 0.5, 90, 16777215, 1);
}
