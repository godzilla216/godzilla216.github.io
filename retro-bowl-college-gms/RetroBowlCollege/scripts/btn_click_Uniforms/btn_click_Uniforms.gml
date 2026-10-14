function btn_click_Uniforms() {
	obj_master.force_uniforms++;
	if (obj_master.force_uniforms > 3) {
		obj_master.force_uniforms = 0;
	}
	room_goto(rm_pre_match);
}

