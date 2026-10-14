title = s_str("ui_StarRating") + " " + string(round(old_percent)) + "%";
old_percent = lerp(old_percent, obj_master.starrating, 0.1);
