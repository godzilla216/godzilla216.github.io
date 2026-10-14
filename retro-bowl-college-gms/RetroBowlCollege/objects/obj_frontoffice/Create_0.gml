obj_master.fa_page = 1;
if (obj_master.intro) {
	inst_100186.active = false;
	inst_100183.active = false;
	inst_100182.active = false;
}
inst_100164.text = "";
inst_100165.text = "";
inst_100166.text = "";
if (obj_master.facility_stadium < 10) {
	inst_100164.text = string(obj_master.facility_stadium + 1);
} else {
	inst_100164.active = false;
}
if (obj_master.facility_training < 10) {
	inst_100165.text = string(obj_master.facility_training + 1);
} else {
	inst_100165.active = false;
}
if (obj_master.facility_rehab < 10) {
	inst_100166.text = string(obj_master.facility_rehab + 1);
} else {
	inst_100166.active = false;
}
var uniform = instance_create_layer(0, 0, "Instances", obj_uniform);
uniform.visible = false;
s_load_uniform_file2(obj_master.myteam_id, uniform, 0, "");
slog("FACEHUNT: obj_front_office - Creating staff!");
inst_100187.pmap = s_get_staff(100);
slog("FACEHUNT: obj_front_office - profile_HC.pmap pos[" + string(ds_map_find_value(inst_100187.pmap, "position")) + "]");
inst_100175.pmap = s_get_staff(101);
inst_100174.pmap = s_get_staff(102);
with (inst_100187) {
	s_set_up_uniform_profile(uniform);
}
with (inst_100175) {
	s_set_up_uniform_profile(uniform);
}
with (inst_100174) {
	s_set_up_uniform_profile(uniform);
}
inst_100178.text = s_get_string_picks(false);
s_check_intro();
s_check_intro_rm_frontoffice();
if (obj_master.intro == 0 && obj_master.myface_x < 0) {
	s_msg(s_str("msg_NeedBossHead"));
}
if (s_is_co_mode()) {
	inst_100183.visible = false;
	inst_100181.visible = false;
	inst_100186.visible = false;
	var upgradeShipFund = instance_create_layer(inst_100181.x, inst_100181.y, "Instances", obj_button_9s, {
		onClickAction: btn_click_Boost_Salary_Cap,
		image: spr_credit,
		text: string(100),
		image_xscale: 1.9393
	});
	if (obj_master.intro > 0) {
		upgradeShipFund.active = false;
	}
	inst_100177.visible = false;
	inst_100178.visible = false;
	inst_100179.visible = false;
	inst_100182.x = inst_100177.x;
	if (global.mobile_device) {
		inst_100184.x = inst_100182.x - 40;
	}
}
