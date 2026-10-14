title = obj_master.qb_mode ? s_str("ui_Team") : s_str("ui_Morale");
image = spr_attitude;
old_percent = s_get_morale();
image_num = s_get_attitude_icon(old_percent);
text = string(round(old_percent)) + "%";
