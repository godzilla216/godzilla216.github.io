if (img) {
	draw_sprite_ext(img, subimg, x, y, imgscl, imgscl, 0, 16777215, 1);
} else {
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(1);
	draw_set_valign(1);
	draw_hd_text_transformed_color(x - 1, y + 1, txt, 2, 2, 0, 16777215, 16777215, 16777215, 16777215, alpha * 0.25);
	draw_hd_text_transformed_color(x, y, txt, 2, 2, 0, colour, colour, colour, colour, alpha);
}
