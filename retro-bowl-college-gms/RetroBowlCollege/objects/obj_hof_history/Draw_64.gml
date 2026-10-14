function s_draw_history_line(_arg0, _arg1, _arg2, _arg3, _arg4) {
	if (_arg2 >= _arg3 && _arg2 <= _arg4) {
		var map = ds_list_find_value(obj_master.history, _arg0);
		draw_set_halign(1);
		draw_hd_text(_arg1, _arg2, ds_map_find_value(map, "year"));
		_arg1 += 24;
		draw_hd_text(_arg1, _arg2, ds_map_find_value(map, "tla"));
		_arg1 += 44;
		draw_hd_text(_arg1, _arg2, string(ds_map_find_value(map, "wins")) + "-" + string(ds_map_find_value(map, "losses")) + "-" + string(ds_map_find_value(map, "ties")));
		_arg1 += 44;
		draw_set_halign(2);
		draw_hd_text(other.x + other.sprite_width - 18, _arg2, ds_map_find_value(map, "finish"));
	}
}

function s_draw_history_lines_college(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5) {
	var map = ds_list_find_value(obj_master.history, _arg0);
	var farRightX = other.x + other.sprite_width - 18;
	var yearTeam = string(ds_map_find_value(map, "year")) + " " + ds_map_find_value(map, "tla");
	var recYear = real(ds_map_find_value(map, "year"));
	if (recYear == obj_master.year) {
		return 0;
	}
	var c1 = "";
	var c2 = "";
	var confTLA = "";
	var comp, thisConf;
	if (_arg2 >= _arg4 && _arg2 <= _arg5) {
		draw_set_halign(0);
		draw_hd_text(_arg1, _arg2, yearTeam);
		c1 = "";
		c1 += string(ds_map_find_value(map, "wins_cnf")) + "-" + string(ds_map_find_value(map, "losses_cnf")) + " ";
		draw_set_halign(0);
		draw_hd_text(_arg1 + 44, _arg2, c1);
		c2 = "";
		confTLA = "";
		thisConf = s_get_struct_in_array_by_uid(obj_master.conferences, ds_map_find_value(map, "conference"));
		if (thisConf == -4) {
			c2 += "NO CONF DATA! ";
		} else {
			confTLA = thisConf.tla;
			c2 += confTLA + " ";
			if (thisConf.divisions > 1) {
				if (ds_map_find_value(map, "division") == 0) {
					c2 += thisConf.div_0_name + " ";
				}
				if (ds_map_find_value(map, "division") == 1) {
					c2 += thisConf.div_1_name + " ";
				}
			}
			c2 += s_str_int_to_ordinal(s_get_map_real(map, "conference_finish_place", -1) + 1);
		}
		draw_set_halign(2);
		draw_hd_text(farRightX, _arg2, c2);
	}
	_arg2 += _arg3;
	var subdivName = "";
	if (ds_map_find_value(map, "subdivision") != "") {
		if (ds_map_find_value(map, "subdivision") == "FCS") {
			subdivName = "MINOR";
		}
		if (ds_map_find_value(map, "subdivision") == "FBS") {
			subdivName = "MAJOR";
		}
		if (_arg2 >= _arg4 && _arg2 <= _arg5) {
			draw_set_halign(0);
			draw_hd_text(_arg1, _arg2, yearTeam);
			c1 = "";
			c1 += string(ds_map_find_value(map, "wins")) + "-" + string(ds_map_find_value(map, "losses")) + " ";
			draw_set_halign(0);
			draw_hd_text(_arg1 + 44, _arg2, c1);
			c2 = "";
			if (ds_map_find_value(map, "subdivision") == "FCS") {
				c2 += subdivName + " ";
			}
			if (ds_map_find_value(map, "subdivision") == "FBS") {
				c2 += subdivName + " ";
			}
			c2 += s_str("ui_Ranked") + " " + s_str_int_to_ordinal(s_get_map_real(map, "subdivision_rank", -1) + 1);
			draw_set_halign(2);
			draw_hd_text(farRightX, _arg2, c2);
		}
		_arg2 += _arg3;
	}
	if (s_get_map_real(map, "conf_champ_win", -1) != -1) {
		if (_arg2 >= _arg4 && _arg2 <= _arg5) {
			draw_set_halign(0);
			draw_hd_text(_arg1, _arg2, yearTeam);
			c2 = "";
			c2 += confTLA + " " + s_str("ui_Champions_short");
			draw_set_halign(2);
			draw_hd_text(farRightX, _arg2, c2);
		}
		_arg2 += _arg3;
	}
	if (s_get_map_real(map, "conf_armynavy_win", -1) != -1) {
		if (_arg2 >= _arg4 && _arg2 <= _arg5) {
			draw_set_halign(0);
			draw_hd_text(_arg1, _arg2, yearTeam);
			c2 = "";
			comp = s_get_competition(ds_map_find_value(map, "conf_armynavy_win"));
			c2 += comp.name + " " + s_str("ui_Champions_short");
			draw_set_halign(2);
			draw_hd_text(farRightX, _arg2, c2);
		}
		_arg2 += _arg3;
	}
	var playoff_round = s_get_map_real(map, "playoff_round_reach", -1);
	if (playoff_round != -1) {
		if (_arg2 >= _arg4 && _arg2 <= _arg5) {
			draw_set_halign(0);
			draw_hd_text(_arg1, _arg2, yearTeam);
			c2 = "MINOR " + s_str("ui_PositionShort") + " " + s_str("ui_ReachRoundShort" + string(playoff_round));
			draw_set_halign(2);
			draw_hd_text(farRightX, _arg2, c2);
		}
		_arg2 += _arg3;
	}
	if (s_get_map_real(map, "won_bowl", -1) != -1) {
		if (_arg2 >= _arg4 && _arg2 <= _arg5) {
			draw_set_halign(0);
			draw_hd_text(_arg1, _arg2, yearTeam);
			c2 = "";
			comp = s_get_competition(ds_map_find_value(map, "won_bowl"));
			c2 += comp.name + " " + s_str("ui_Champions_short");
			draw_set_halign(2);
			draw_hd_text(farRightX, _arg2, c2);
		}
		_arg2 += _arg3;
	}
	if (ds_map_find_value(map, "subdivision_champ") == "loss") {
		if (_arg2 >= _arg4 && _arg2 <= _arg5) {
			draw_set_halign(0);
			draw_hd_text(_arg1, _arg2, yearTeam);
			c2 = "";
			c2 += subdivName + " " + s_str("ui_ChampRunnerUp");
			draw_set_halign(2);
			draw_hd_text(farRightX, _arg2, c2);
		}
		_arg2 += _arg3;
	}
	if (ds_map_find_value(map, "subdivision_champ") == "win") {
		if (_arg2 >= _arg4 && _arg2 <= _arg5) {
			draw_set_halign(0);
			draw_hd_text(_arg1, _arg2, yearTeam);
			c2 = "";
			c2 += subdivName + " " + s_str("ui_Champions_short");
			draw_set_halign(2);
			draw_hd_text(farRightX, _arg2, c2);
		}
		_arg2 += _arg3;
	}
}

draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var tx = x + 6;
var ty = y + 12;
var bounds_y1 = ty + txt_h - 4;
var bounds_y2 = ty + sprite_height - 16;
with (obj_master) {
	draw_set_halign(0);
	draw_hd_text_color(tx - 1, ty + 1, s_str("ui_Year"), 0, 0, 0, 0, 1);
	draw_hd_text(tx, ty, s_str("ui_Year"));
	tx += 72;
	draw_set_halign(1);
	draw_hd_text_color(tx - 1, ty + 1, s_str("ui_Record"), 0, 0, 0, 0, 1);
	draw_hd_text(tx, ty, s_str("ui_Record"));
	draw_set_halign(2);
	tx = other.x + other.sprite_width - 18;
	draw_hd_text_color(tx - 1, ty + 1, s_str("ui_Finished"), 0, 0, 0, 0, 1);
	draw_hd_text(tx, ty, s_str("ui_Finished"));
	ty += other.yoffset;
	ty += other.txt_h;
	var _size = ds_list_size(history);
	for (var i = _size - 1; i > -1; i--) {
		tx = other.x + 10;
		if (s_is_co_mode()) {
			s_draw_history_lines_college(i, tx, ty, other.txt_h, bounds_y1, bounds_y2);
		} else {
			s_draw_history_line(i, tx, ty, bounds_y1, bounds_y2);
		}
		ty += other.txt_h * s_history_display_lines_count_yearindex(i);
	}
}
draw_rectangle_color(x, y + sprite_height, x + sprite_width, y + sprite_height + 2, global.c_background, global.c_background, global.c_background, global.c_background, 0);
event_inherited();
if (yoffset < 0) {
	draw_sprite_ext(spr_arrowL2, 0, x + sprite_width - 10, y + 24, 0.5, 0.5, -90, 16777215, 1);
}
if (yoffset > clampsize + 10) {
	draw_sprite_ext(spr_arrowL2, 0, x + sprite_width - 10, y + sprite_height - 12, 0.5, 0.5, 90, 16777215, 1);
}
