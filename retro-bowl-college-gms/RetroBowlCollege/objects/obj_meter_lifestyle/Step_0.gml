title = s_str("ui_Lifestyle") + " " + string(s_get_lifestyle()) + "%";
old_percent = lerp(old_percent, s_get_lifestyle(), 0.1);
if (old_percent > 25) {
	colour = global.c_primary;
}
