function s_destroy_match_objects() {
	slog("s_destroy_match_objects");
	with (obj_player) {
		layer_sprite_destroy(my_shadow);
	}
	with (global.master_ball) {
		layer_sprite_destroy(my_shadow);
	}
	instance_destroy(obj_player);
	instance_destroy(obj_ball);
	instance_destroy(obj_metaball);
	instance_destroy(obj_dummy);
	instance_destroy(obj_boundary);
	instance_destroy(obj_btn_audible);
	instance_destroy(obj_btn_timeout);
	instance_destroy(obj_btn_fieldgoal);
	instance_destroy(obj_btn_goforit);
}

