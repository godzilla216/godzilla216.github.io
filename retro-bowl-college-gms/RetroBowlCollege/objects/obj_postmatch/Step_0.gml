s_update_music();
inst_100483.text = s_get_credit();
with (obj_msgbg) {
	if (depth < other.depth) {
		stage_time = current_time;
		exit;
	}
}
if (!obj_master.fans_done_update) {
	inst_100482.old_percent = obj_master.fans;
	if (!obj_master.qb_mode) {
		s_do_postmatch_fans();
	}
}
if (current_time < stage_time + (stage + 1) * 500) {
	exit;
}
switch (stage) {
	case 0:
		other.stage++;
		break;
	case 1:
		var cx1 = inst_100482.x + inst_100482.sprite_width * 0.16;
		var cx2 = inst_100482.x + inst_100482.sprite_width * 0.5;
		var cx3 = inst_100482.x + inst_100482.sprite_width * 0.82;
		var cy = inst_100482.y + inst_100482.sprite_height * 0.5;
		var dx = inst_100483.x + inst_100483.sprite_width * 0.5;
		var dy = inst_100483.y + inst_100483.sprite_height * 0.5;
		s_create_credit(cx1, cy, dx, dy, 1, 1, -4, true);
		if (obj_master.fans > 33) {
			s_create_credit(cx2, cy, dx, dy, 1, 1, -4, false);
		}
		if (obj_master.fans > 66) {
			s_create_credit(cx3, cy, dx, dy, 1, 1, -4, false);
		}
		if (won_match && obj_master.week == s_get_week_superbowl()) {
			s_create_credit(cx3 + 10, cy, dx, dy, 10, 1, -4, false);
		}
		stage++;
		break;
	case 2:
		if (!instance_exists(obj_credit)) {
			inst_100479.visible = true;
			inst_100481.visible = true;
			if (!global.poki) {
				inst_100488.visible = true;
			}
		}
		break;
}
