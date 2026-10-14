slog("obj_team_editor.create:" + string(obj_master.edit_conf));
var bx = 44;
var by = 72;
for (var b = 0; b < 16; b++) {
	btn[b] = instance_create_layer(bx, by, "Instances", obj_button);
	btn[b].onClickAction = btn_click_EditTeam;
	btn[b].sprite_index = spr_button_104;
	bx += 108;
	if (bx > 378) {
		bx = 44;
		by += 38;
	}
}
inst_100566.text = s_str("ui_SaveSlot" + string(ds_map_find_value(obj_master.map_options, "saveslot")));
s_update_team_edit_buttons();
if (!file_exists(global.g_savename1) || !file_exists("uniforms_custom_1.txt")) {
	inst_100558.active = false;
}
if (!file_exists(global.g_savename2) || !file_exists("uniforms_custom_2.txt")) {
	inst_100559.active = false;
}
if (!file_exists(global.g_savename3) || !file_exists("uniforms_custom_3.txt")) {
	inst_100564.active = false;
}
if (!file_exists(global.g_savename4) || !file_exists("uniforms_custom_4.txt")) {
	inst_100565.active = false;
}
if (!file_exists(global.g_savename5) || !file_exists("uniforms_custom_5.txt")) {
	inst_100567.active = false;
}
switch (ds_map_find_value(obj_master.map_options, "saveslot")) {
	case 1:
		inst_100558.active = false;
		inst_100558.text = s_str("ui_Current");
		break;
	case 2:
		inst_100559.active = false;
		inst_100559.text = s_str("ui_Current");
		break;
	case 3:
		inst_100564.active = false;
		inst_100564.text = s_str("ui_Current");
		break;
	case 4:
		inst_100565.active = false;
		inst_100565.text = s_str("ui_Current");
		break;
	case 5:
		inst_100567.active = false;
		inst_100567.text = s_str("ui_Current");
		break;
}
