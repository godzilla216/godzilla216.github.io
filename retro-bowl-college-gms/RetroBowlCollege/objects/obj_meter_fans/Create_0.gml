old_percent = obj_master.fans;
title = s_str("ui_Fans") + " " + string(round(old_percent)) + "%";
if (old_percent > 25) {
	colour = global.c_primary;
}
