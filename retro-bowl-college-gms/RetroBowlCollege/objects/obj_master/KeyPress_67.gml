if (!global.debug) {
	exit;
}
with (obj_input_box) {
	exit;
}
with (obj_controller) {
	exit;
}
if (!instance_exists(obj_msgbg) && !instance_exists(obj_input_box)) {
	obj_master.coach_credit += 100;
	ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 10);
	obj_master.season_credits_purchased += 100;
	audio_play_sound(snd_purchase, 1, false);
	s_meter_change(8, obj_master.coach_credit, current_room, "Coins!");
}
