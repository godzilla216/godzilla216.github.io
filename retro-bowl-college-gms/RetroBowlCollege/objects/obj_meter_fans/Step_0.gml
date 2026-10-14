title = s_str("ui_Fans") + " " + string(round(old_percent)) + "%";
old_percent = lerp(old_percent, obj_master.fans, 0.1);
if (old_percent > 25) {
	colour = global.c_primary;
}
