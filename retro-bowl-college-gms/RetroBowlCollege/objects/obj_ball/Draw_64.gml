if (obj_controller.kicking && s_aiming()) {
	s_draw_kicking_power();
}
exit;
if (global.master_ball != id) {
	exit;
}
draw_set_halign(0);
draw_hd_text(10, 30, s_get_string_ball_state());
draw_hd_text(10, 40, string(round(height)));
draw_hd_text(10, 50, "Kicking = " + string(obj_controller.kicking));
