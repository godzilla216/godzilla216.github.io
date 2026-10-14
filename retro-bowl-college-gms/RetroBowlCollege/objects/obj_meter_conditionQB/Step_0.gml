old_percent = lerp(old_percent, s_get_qb_energy(), 0.1);
title = s_str("ui_Condition") + " " + string(round(old_percent)) + "%";
colour = s_get_condition_colour(old_percent, 65280);
