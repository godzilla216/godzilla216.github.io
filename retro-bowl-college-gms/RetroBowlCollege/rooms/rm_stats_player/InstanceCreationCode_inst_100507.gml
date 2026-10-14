switch (ds_map_find_value(obj_master.player_profile, "position")) {
	case 1:
		break;
	case 2:
		text = s_str("ui_Receiving");
		break;
	default:
		visible = false;
}
if (obj_master.stat_view == 1) {
	colour = global.c_primary;
}
if (s_is_co_mode()) {
	visible = false;
}
