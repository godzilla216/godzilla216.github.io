old_percent = obj_master.relationship_boss;
title = s_str("ui_Coach") + " " + string(round(old_percent)) + "%";
if (old_percent > 25) {
	colour = global.c_primary;
}
