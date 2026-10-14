old_percent = s_get_morale();
title = s_str("ui_Team") + " " + string(round(old_percent)) + "%";
if (old_percent > 25) {
	colour = global.c_primary;
}
