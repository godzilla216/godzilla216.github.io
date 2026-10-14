if (s_is_co_mode()) {
	visible = false;
	exit;
}
if (draw_box) {
	if (shadow) {
		draw_sprite_ext(sprite_index, 0, x - 2, y + 2, image_xscale, image_yscale, 0, 4210752, alpha);
	}
	draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, colour, alpha);
}
draw_set_font(font);
draw_set_halign(halign);
draw_set_valign(valign);
var tx = x - 16;
var ty = y;
if (draft_round >= 0 && draft_round <= 2) {
	alf[draft_round] = (sin(current_time / 160) + 1) / 2;
}
draw_hd_text_color(tx, ty, pick1, tcolour, tcolour, tcolour, tcolour, alf[0]);
tx += 8;
draw_hd_text_color(tx, ty, "-", tcolour, tcolour, tcolour, tcolour, 1);
tx += 8;
draw_hd_text_color(tx, ty, pick2, tcolour, tcolour, tcolour, tcolour, alf[1]);
tx += 8;
draw_hd_text_color(tx, ty, "-", tcolour, tcolour, tcolour, tcolour, 1);
tx += 8;
draw_hd_text_color(tx, ty, pick3, tcolour, tcolour, tcolour, tcolour, alf[2]);
