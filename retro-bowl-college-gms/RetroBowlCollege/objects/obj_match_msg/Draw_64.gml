if (text == "") {
	exit;
}
var buf = 20;
draw_set_font(global.fnt_flex);
draw_set_halign(1);
draw_set_valign(1);
var f = (sin(current_time / 80) + 1) / 2;
if (!flash) {
	f = 1;
}
draw_set_alpha(bg_alpha);
var buf2 = 0;
if (sub_text != "") {
	buf2 = 15;
}
draw_rectangle_color(0, ty - buf, w, ty + buf + buf2, 0, 0, 0, 0, 0);
draw_set_alpha(1);
var scl = 1;
if (instance_exists(obj_controller)) {
	scl = 1.5;
}
draw_hd_text_transformed_color(tx - 1, ty + 1, text, scl, scl, 0, 0, 0, 0, 0, f * 0.5);
draw_hd_text_transformed_color(tx, ty, text, scl, scl, 0, col, col, col, col, f);
if (sub_text != "") {
	draw_set_font(global.fnt_small_flex);
	draw_hd_text_transformed_color(tx, ty + 25, sub_text, 1, 1, 0, 16777215, 16777215, 16777215, 16777215, 1);
}
