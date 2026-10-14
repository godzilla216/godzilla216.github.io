function s_cpu_is_kicking_off() {
	if (obj_controller.kicking == 3) {
		return true;
	}
}

function s_is_kickoff(_arg0) {
	if (obj_master.gamepractice) {
		return false;
	}
	if (_arg0 && obj_controller.down == 99) {
		return true;
	}
	if (obj_controller.kicking == 3) {
		return true;
	} else {
		return false;
	}
}

