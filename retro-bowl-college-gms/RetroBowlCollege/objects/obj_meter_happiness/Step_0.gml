old_percent = lerp(old_percent, s_get_happiness(), 0.1);
title = s_str("ui_Happiness") + " " + string(round(old_percent)) + "%";
if (old_percent > 25) {
	colour = global.c_primary;
}
