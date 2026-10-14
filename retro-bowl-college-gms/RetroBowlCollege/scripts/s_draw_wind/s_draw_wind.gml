function s_draw_wind() {
	if (!kicking && !instance_exists(obj_msgbg)) {
		return;
	}
	if (!s_aiming()) {
		return;
	}
	if (!instance_exists(obj_weather) || obj_weather.wind == 0) {
		return;
	}
	if (s_is_kickoff(true)) {
		return;
	}
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(1);
	draw_set_valign(1);
	var gw = display_get_gui_width();
	var c = 0;
	var posx = 48;
	var posy = 40;
	if (obj_controller.drivedir == -1) {
		posx = gw - posx;
	}
	if (instance_exists(obj_msgbg)) {
		posx = gw - posx;
	}
	var rw = 48;
	var rx = posx - rw * 0.5;
	var ry = posy - rw * 0.5;
	draw_rectangle_color(rx, ry, rx + rw, ry + rw + 16, c, c, c, c, 0);
	rx = posx;
	ry = posy;
	draw_sprite_ext(spr_wind, 0, rx, ry, 1.5, 1.5, obj_weather.wind_dir * 45, 16777215, 1);
	draw_hd_text(rx, ry + 30, s_str("match_Wind") + " " + string(obj_weather.wind));
}

