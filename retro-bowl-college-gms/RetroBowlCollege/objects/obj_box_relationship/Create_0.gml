image = spr_attitude;
switch (relationship_type) {
	case 0:
		title = s_str("ui_Coach");
		percent = obj_master.relationship_boss;
		break;
	case 1:
		title = s_str("ui_Team");
		percent = s_get_morale();
		break;
	case 2:
		title = s_str("ui_Fans");
		percent = obj_master.fans;
		break;
}
image_num = s_get_attitude_icon(percent);
text = string(round(percent)) + "%";
