function s_last_secs_of_half(_arg0) {
	with (obj_controller) {
		var rsecs = minutes * 60 + seconds;
		if ((quarter == 2 || quarter == 4 || quarter == 5) && rsecs <= _arg0) {
			return true;
		}
	}
	return false;
}

function s_seconds_remaining() {
	with (obj_controller) {
		var rsecs = minutes * 60 + seconds;
		if (quarter == 1 || quarter == 3) {
			rsecs += (2 + obj_master.op_matchlength) * 60;
		}
		return rsecs;
	}
}

