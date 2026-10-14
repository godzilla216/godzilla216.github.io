if (!active) {
	exit;
}
switch (relationship_type) {
	case 0:
		percent = lerp(percent, obj_master.relationship_boss, 0.1);
		break;
	case 1:
		percent = lerp(percent, s_get_morale(), 0.1);
		break;
	case 2:
		percent = lerp(percent, obj_master.fans, 0.1);
		break;
}
image_num = s_get_attitude_icon(percent);
text = string(round(percent)) + "%";
