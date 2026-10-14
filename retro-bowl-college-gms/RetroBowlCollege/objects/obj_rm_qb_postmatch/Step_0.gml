with (obj_msgbg) {
	if (depth < other.depth) {
		stage_time = current_time;
		exit;
	}
}
inst_100685.text = s_get_credit();
if (s_is_touch_allowed() && mouse_check_button(1)) {
	delay = 250;
}
if (current_time < stage_time + (stage + 1) * delay) {
	exit;
}
stage++;
var dx = inst_100685.x + inst_100685.sprite_width * 0.5;
var dy = inst_100685.y + inst_100685.sprite_height * 0.5;
switch (stage) {
	case 0:
		break;
	case 1:
		inst_100689.visible = true;
		break;
	case 2:
		inst_100690.visible = true;
		obj_master.relationship_boss = clamp(obj_master.relationship_boss + coach_effect, 1, 100);
		break;
	case 3:
		inst_100691.visible = true;
		inst_100697.active = true;
		break;
	case 4:
		inst_100692.visible = true;
		obj_master.fans = clamp(obj_master.fans + fan_effect, 1, 100);
		if (obj_master.fans >= 100) {
			s_complete_achievement("ACH_FANS100");
		}
		break;
	case 5:
		inst_100693.visible = true;
		var tob = 100693;
		s_create_credit(tob.x + string_hd_width(tob.text) * 0.5, tob.y, dx, dy, obj_master.qb_salary, 1, -4, true);
		break;
	case 6:
		inst_100694.visible = true;
		var tob = 100694;
		s_create_credit(tob.x + string_hd_width(tob.text) * 0.5, tob.y, dx, dy, bonus, 1, -4, true);
		break;
	case 7:
		break;
	case 8:
		inst_100695.visible = true;
		break;
}
