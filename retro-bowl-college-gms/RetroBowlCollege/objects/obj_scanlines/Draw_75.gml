var gw = display_get_gui_width();
var gh = display_get_gui_height();
var col = global.c_background;
if (room == rm_title) {
	col = 0;
}
if (room == rm_master && !instance_exists(obj_msgbg)) {
	col = 0;
}
if (room == rm_match) {
	col = 0;
}
draw_rectangle_color(-1080, -1080, -1, 1080, col, col, col, col, 0);
draw_rectangle_color(gw, -1080, gw + 1080, 1080, col, col, col, col, 0);
draw_rectangle_color(-1080, -1080, gw + 1080, -1, col, col, col, col, 0);
draw_rectangle_color(-1080, gh, gw + 1080, gh + 1080, col, col, col, col, 0);
var _on = self.on;
var alf = 0.08;
var scl = 0.5;
with (obj_controller) {
	if (state == 3) {
		_on = true;
	}
}
if (_on) {
	draw_sprite_tiled_ext(spr_scanlines, 0, -540, -540, scl, scl, 16777215, alf);
}
if (instance_exists(obj_master) && obj_master.alarm[1] > 0) {
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(2);
	var gx = display_get_gui_width();
	var gy = display_get_gui_height();
	draw_set_color(0);
	draw_set_alpha(0.75);
	draw_rectangle(gx - 110, gy - 16, gx, gy, 0);
	draw_set_color(16777215);
	draw_set_alpha(1);
	draw_hd_text(gx - 6, gy - 8, s_str("ui_Connecting"));
	draw_sprite_ext(spr_connect, 0, gx - 102, gy - 7, 1, 1, (current_time / 5) mod 360, 16777215, 1);
}
if (window_get_cursor() == -1) {
	draw_set_alpha(0.1);
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	draw_circle_color(mx, my, 4, 16777215, 16777215, 0);
	draw_set_alpha(1);
}
if (s_is_debug_desktop() && !s_is_touch_allowed()) {
	draw_set_font(global.fnt_small_flex);
	draw_hd_text(display_get_gui_width() / 2, display_get_gui_height() - 20, "NO TOUCH");
}
