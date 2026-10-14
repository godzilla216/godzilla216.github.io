if (global.browser && !instance_exists(obj_controller)) {
	s_update_poki_scaling();
}
s_update_gamepad();
if (global.debug) {
	s_debug_window_size();
}
