old_percent = lerp(old_percent, s_get_morale(), 0.1);
image_num = s_get_attitude_icon(old_percent);
text = string(round(old_percent)) + "%";
