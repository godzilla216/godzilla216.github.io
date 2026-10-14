with (obj_msgbg) {
	if (depth < other.depth) {
		exit;
	}
}
with (obj_input_box) {
	if (editing) {
		exit;
	}
}
var sx1 = x + sprite_width * 0.3;
var sx2 = x + sprite_width * 0.7;
var sy = y + 22;
if (offense > 0) {
	draw_sprite_ext(spr_star_rating_cb, offense, sx1, sy, 1, 1, 0, global.c_offense, 1);
}
if (defense > 0) {
	draw_sprite_ext(spr_star_rating_cb, defense, sx2, sy, 1, 1, 0, global.c_defense, 1);
}
