if (custom_draw_gui != -4) {
	custom_draw_gui();
	exit;
}
draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var tx = x + sprite_width / 2;
var ty = y + sprite_height / 2;
tx += 1;
ty -= 1;
if (!active) {
	draw_sprite_ext(sprite_index, 1, x + 2, y - 2, 1, 1, 0, 4210752, 1);
	draw_set_color(4210752);
	if (image) {
		draw_sprite(image, image_num, tx, ty);
	} else {
		draw_hd_text(tx, ty, string_upper(text));
	}
	draw_set_color(16777215);
} else if (!clicked) {
	var f = (sin(current_time / 60) + 1) / 2;
	with (obj_msgbg) {
		if (depth < other.depth) {
			f = 0;
		}
	}
	if (s_is_new_shadow()) {
		draw_sprite_ext(sprite_index, 1, x, y, 1, 1, 0, global.c_shadow, 1);
		draw_sprite(sprite_index, 1, x + 2, y - 2);
	} else {
		draw_sprite(sprite_index, image_index, x, y);
	}
	if (s_is_ui_selected()) {
		draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, s_ui_selected_color(), 1);
	}
	draw_sprite_ext(sprite_index, 2, x, y, 1, 1, 0, colour, 1);
	if (flash && f > 0.5) {
		draw_sprite_ext(sprite_index, 2, x, y, 1, 1, 0, global.c_primary, 1);
	}
	if (continue_icon) {
		draw_sprite(continue_icon, 0, x + sprite_width - 8, y + sprite_height * 0.5 - 1);
	}
	draw_set_color(colour_text);
	if (image) {
		draw_sprite(image, image_num, tx, ty);
	} else {
		draw_hd_text(tx, ty, string_upper(text));
	}
	draw_set_color(16777215);
} else {
	draw_sprite(sprite_index, image_index, x, y);
	draw_sprite_ext(sprite_index, 2, x - 2, y + 2, 1, 1, 0, colour, 1);
	if (continue_icon) {
		draw_sprite(continue_icon, 0, x + sprite_width - 10, y + sprite_height * 0.5 + 1);
	}
	draw_set_color(colour_text);
	if (image) {
		draw_sprite(image, image_num, tx - 2, ty + 2);
	} else {
		draw_hd_text(tx - 2, ty + 2, string_upper(text));
	}
	draw_set_color(16777215);
}
