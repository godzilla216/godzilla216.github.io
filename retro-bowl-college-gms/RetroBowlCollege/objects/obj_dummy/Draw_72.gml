var c = s_is_co_mode() ? make_colour_rgb(29, 73, 114) : 32768;
var w = 5;
var rx = range_x;
var ry = range_y;
draw_set_alpha(0.5);
if (rx) {
	draw_rectangle_colour(x - rx, start_y - w, x + rx, start_y + w, c, c, c, c, 0);
} else if (ry) {
	draw_rectangle_colour(x - w, start_y - ry, x + w, start_y + ry, c, c, c, c, 0);
}
draw_set_alpha(1);
if (obj_master.gamepractice == 3) {
	if (sin(current_time / 200) > 0.1) {
		draw_sprite_ext(spr_pointer, 0, x, y - 32, 2, 2, 0, 65280, 1);
	}
}
