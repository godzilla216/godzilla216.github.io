old_percent = s_get_lifestyle();
title = s_str("ui_Lifestyle") + " " + string(old_percent) + "%";
if (old_percent > 25) {
	colour = global.c_primary;
}
