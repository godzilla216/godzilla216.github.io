function s_qb_run(_arg0) {
	if (obj_master.gamepractice == 3 || obj_master.gamepractice == 4) {
		state = 0;
	} else if (holder.anim == 11 || _arg0) {
		if (global.gamepad) {
			global.gp.axisr_flick = true;
		}
		obj_controller.play_start = current_time;
		obj_controller.running_play = true;
		state = 5;
		last_touched_by = holder;
		velocity = 0;
		zvel = 0;
		with (holder) {
			qb_rushing = true;
			position = 2;
			s_set_anim(2);
		}
	}
}

function s_qb_revert_throw() {
	with (holder) {
		if (position == 2 && pmap && ds_map_find_value(pmap, "position") == 1) {
			hspeed = 0;
			vspeed = 0;
			position = 1;
			s_set_anim(0);
		} else {
			return;
		}
	}
	state = 0;
	last_touched_by = holder;
	velocity = 0;
	zvel = 0;
}

