draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var f = (sin(current_time / 60) + 1) / 2;
var tx = x + sprite_width / 2;
var ty = y + sprite_height / 2;
tx += 1;
ty -= 1;
if (!active) {
	if (!image_only) {
		draw_sprite_ext(sprite_index, 1, x + 2, y - 2, 1, 1, 0, 4210752, 1);
	}
	if (image) {
		draw_sprite_ext(image, 0, tx, ty - 1, 1, 1, 0, 4210752, 1);
	} else {
		draw_hd_text(tx, ty, string_upper(text));
	}
} else if (!clicked) {
	if (!image_only) {
		if (s_is_new_shadow()) {
			draw_sprite_ext(sprite_index, 1, x, y, 1, 1, 0, global.c_shadow, 1);
			draw_sprite_ext(sprite_index, 1, x + 2, y - 2, 1, 1, 0, 16777215, 1);
		} else {
			draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, 16777215, 1);
		}
		if (s_is_ui_selected()) {
			draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, s_ui_selected_color(), 1);
		}
		draw_sprite_ext(sprite_index, 2, x, y, 1, 1, 0, colour, 1);
		with (obj_msgbg) {
			if (depth < other.depth) {
				f = 0;
			}
		}
		if (flash && f > 0.5) {
			draw_sprite_ext(sprite_index, 2, x, y, 1, 1, 0, global.c_primary, 1);
		}
	}
	if (image) {
		draw_sprite_ext(image, 0, tx - 1, ty + 1, 1, 1, 0, 4210752, 1);
		if (s_is_ui_selected()) {
			draw_sprite_ext(image, 0, tx, ty, 1, 1, 0, s_ui_selected_color(), 1);
		} else {
			draw_sprite(image, 0, tx, ty);
		}
	} else {
		draw_hd_text(tx, ty, string_upper(text));
	}
} else {
	if (!image_only) {
		draw_sprite_ext(sprite_index, 1, x, y, 1, 1, 0, 16777215, 1);
		draw_sprite_ext(sprite_index, 2, x - 2, y + 2, 1, 1, 0, colour, 1);
	}
	if (image) {
		if (s_is_ui_selected() && f > 0.5 && image_only) {
			draw_sprite_ext(image, 0, tx - 2, ty + 2, 1, 1, 0, s_ui_selected_color(), 1);
		} else {
			draw_sprite(image, 0, tx - 2, ty + 2);
		}
	} else {
		draw_hd_text(tx - 2, ty + 2, string_upper(text));
	}
}
