function s_msg_clear(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = -4;
	}
	if (instance_exists(obj_controller)) {
		with (obj_msgbg) {
			instance_destroy();
		}
		with (obj_roomtitle) {
			if (depth < 0) {
				instance_destroy();
			}
		}
		with (obj_messagebox) {
			if (depth < 0) {
				instance_destroy();
			}
		}
		with (obj_button) {
			if (depth < 0) {
				instance_destroy();
			}
		}
		with (obj_button_big) {
			if (depth < 0) {
				instance_destroy();
			}
		}
		with (obj_notification) {
			if (depth < 0) {
				instance_destroy();
			}
		}
		ds_list_clear(obj_master.list_notifications);
	} else {
		with (all) {
			if (depth <= 0) {
				instance_destroy();
			}
		}
		if (instance_exists(obj_master)) {
			ds_list_clear(obj_master.list_notifications);
		}
	}
}

