function btn_click_BallStyle() {
	with (obj_master) {
		op_ball = real(op_ball) + 1;
		if (op_ball > 5) {
			op_ball = 0;
		}
		with (inst_100397) {
			image_num = other.op_ball;
		}
		with (inst_100395) {
			title = s_str("ui_Ball") + " " + string(other.op_ball + 1);
		}
		with (inst_100790) {
			image_num = other.op_ball;
		}
		with (inst_100788) {
			title = s_str("ui_Ball") + " " + string(other.op_ball + 1);
		}
	}
}

