function btn_click_qb_training() {
	var qb = s_get_qb_pmap();
	if (ds_map_find_value(qb, "condition") < 40) {
		s_do_message(s_str("msg_TrainingEnergyTooLow"));
	} else if (ds_map_find_value(qb, "condition") - 40 <= 40) {
		s_create_message("", s_str("msg_TrainingEnergyConfirm"), s_str("ui_Yes"), s_str("ui_Cancel"), s_do_qb_training, s_msg_clear, global.c_background, 1);
	} else {
		s_do_qb_training();
	}
}

function s_do_qb_training() {
	var qb = s_get_qb_pmap();
	ds_map_set(qb, "condition", clamp(ds_map_find_value(qb, "condition") - 40, 1, 100));
	obj_master.player_profile = qb;
	obj_master.gamepractice = 4;
	s_set_up_uniforms_training();
	room_goto(rm_match);
}

