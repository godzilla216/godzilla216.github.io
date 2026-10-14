function btn_click_Uniform_Home() {
	obj_master.force_uniform_sel2++;
	if (obj_master.force_uniform_sel2 > 3) {
		obj_master.force_uniform_sel2 = 0;
	}
	with (obj_prematch) {
		instance_destroy();
	}
	with (obj_rm_exhibition) {
		instance_destroy();
	}
	if (current_room == rm_pre_match) {
		instance_create_layer(0, 0, "Instances", obj_prematch);
	} else {
		instance_create_layer(0, 0, "Instances", obj_rm_exhibition);
	}
}

