draw_set_font(global.fnt_small_flex);
draw_set_halign(0);
var tx = x + 16;
var ty = y + 16;
for (var l = 0; l < ds_list_size(lines); l++) {
	var txt = ds_list_find_value(lines, l);
	if (string_count("shad_", txt)) {
		draw_hd_text_color(tx - 1, ty + 1, string_replace(txt, "shad_", ""), 0, 0, 0, 0, 1);
	}
	draw_hd_text(tx, ty, string_replace(txt, "shad_", ""));
	ty += 14;
}
