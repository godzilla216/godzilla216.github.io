if (!ds_exists(pmap, 1)) {
	exit;
}
if (pmap == -4) {
	exit;
}
if (!pmap) {
	if (!variable_instance_exists(id, "_face_hunt_error_shown")) {
		slog("FACEHUNT: No pmap set for obj_player_profile!");
	}
	_face_hunt_error_shown = true;
	exit;
}
var isFlashTime = false;
try {
	isFlashTime = current_time < real(ds_map_find_value(pmap, "flash_time")) + 2550;
} catch (e) {
}
if (flash || isFlashTime) {
	if (!global.gamepad) {
		var f = sin(current_time / 120);
		if (f < 0.1) {
			exit;
		}
	}
}
var pos = real(ds_map_find_value(pmap, "position"));
var bx = x + 2;
var by = y - 2;
if (clicked || !active) {
	bx = x;
	by = y;
}
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, global.c_shadow, 1);
var pos_col = s_get_position_colour(pos);
if (ds_map_exists(pmap, "resting") && ds_map_find_value(pmap, "resting")) {
	pos_col = 8421504;
} else if (ds_map_exists(pmap, "condition") && ds_map_find_value(pmap, "condition") < 0) {
	pos_col = 8421504;
} else if (s_is_backup(pmap)) {
	pos_col = 8421504;
} else if (s_is_co_mode() && ds_map_exists(pmap, "suspended") && ds_map_find_value(pmap, "suspended")) {
	pos_col = 8421504;
}
if (current_room == rm_halloffame_players) {
	pos_col = global.c_primary;
}
draw_rectangle_color(bx + 2, by + 2, bx + sprite_width - 3, by + sprite_height * 0.5, pos_col, pos_col, pos_col, pos_col, 0);
if (obj_master.qb_mode && pmap && ds_map_find_value(pmap, "position") == 1) {
	draw_sprite_ext(sprite_index, image_index, bx, by, 1, 1, 0, 65535, 1);
} else {
	draw_sprite(sprite_index, image_index, bx, by);
}
var selectflash = (sin(current_time / 60) + 1) / 2;
if (s_is_ui_selected() && selectflash > 0.5) {
	draw_sprite_ext(sprite_index, image_index, bx, by, 1, 1, 0, s_ui_selected_color(), 1);
}
shader_set(sh_ColorReplaceBlend);
shader_set_uniform_f(global.colorHelmet, 1, 0, 0);
shader_set_uniform_f(global.colorShirt, 0, 1, 0);
shader_set_uniform_f(global.colorPants, 1, 0, 1);
if (s_is_co_mode() && ds_map_exists(pmap, "team_leave_reason") && ds_map_find_value(pmap, "team_leave_reason") == "drafted" && ds_map_exists(pmap, "uniform_record") && ds_map_find_value(pmap, "uniform_record") != "") {
	var draftUniform = s_uniform_cols_from_record(ds_map_find_value(pmap, "uniform_record"));
	shader_set_uniform_f(global.replaceHelmet, draftUniform[0], draftUniform[1], draftUniform[2]);
	shader_set_uniform_f(global.replaceShirt, draftUniform[3], draftUniform[4], draftUniform[5]);
	shader_set_uniform_f(global.replacePants, draftUniform[6], draftUniform[7], draftUniform[8]);
} else {
	shader_set_uniform_f(global.replaceHelmet, helmet[2], helmet[1], helmet[0]);
	shader_set_uniform_f(global.replaceShirt, shirt[2], shirt[1], shirt[0]);
	shader_set_uniform_f(global.replacePants, pants[2], pants[1], pants[0]);
}
if (s_is_staff(ds_map_find_value(pmap, "position"))) {
	switch (ds_map_find_value(pmap, "face_y")) {
		case 0:
			draw_sprite_ext(spr_coaches_01, ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
			break;
		case 1:
			draw_sprite_ext(spr_coaches_02, ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
			break;
		case 2:
			draw_sprite_ext(spr_coaches_03, ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
			break;
		case 3:
			draw_sprite_ext(spr_coaches_04, ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
			break;
	}
} else {
	switch (ds_map_find_value(pmap, "skin")) {
		case 2:
			switch (ds_map_find_value(pmap, "face_y")) {
				case 0:
					draw_sprite_ext(s_face_from_set(spr_light_001, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
				case 1:
					draw_sprite_ext(s_face_from_set(spr_light_002, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
				case 2:
					draw_sprite_ext(s_face_from_set(spr_light_003, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
			}
			break;
		case 1:
			switch (ds_map_find_value(pmap, "face_y")) {
				case 0:
					draw_sprite_ext(s_face_from_set(spr_mix_001, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
			}
			break;
		case 0:
			switch (ds_map_find_value(pmap, "face_y")) {
				case 0:
					draw_sprite_ext(s_face_from_set(spr_dark_001, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
				case 1:
					draw_sprite_ext(s_face_from_set(spr_dark_002, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
				case 2:
					draw_sprite_ext(s_face_from_set(spr_dark_003, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
				case 3:
					draw_sprite_ext(s_face_from_set(spr_dark_004, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
				case 4:
					draw_sprite_ext(s_face_from_set(spr_dark_005, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
				case 5:
					draw_sprite_ext(s_face_from_set(spr_dark_006, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
				case 6:
					draw_sprite_ext(s_face_from_set(spr_dark_006, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
				case 7:
					draw_sprite_ext(s_face_from_set(spr_dark_007, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
				case 8:
					draw_sprite_ext(s_face_from_set(spr_dark_008, pmap), ds_map_find_value(pmap, "face_x"), bx + 16, by + 3, 1, 1, 0, 16777215, 1);
					break;
			}
			break;
	}
}
shader_reset();
draw_set_font(global.fnt_small_flex);
draw_set_valign(1);
draw_set_halign(0);
draw_hd_text(bx + 6, by + 8, s_get_string_position(pos));
draw_set_halign(2);
var att = ds_map_find_value(pmap, "attitude");
var con = ds_map_find_value(pmap, "condition");
var age = real(ds_map_find_value(pmap, "age"));
if (current_room != rm_halloffame_players) {
	if (!flash_attitude || sin(current_time / 200) > 0.1) {
		draw_sprite(spr_attitude, s_get_attitude_icon(att), bx + sprite_width - 9, by + 8);
		switch (show_arrow) {
			case -1:
				draw_sprite_ext(spr_pointer, 0, bx + sprite_width + 9, by + 8, 1, 1, 0, 255, 1);
				break;
			case 0:
				break;
			case 1:
				draw_sprite_ext(spr_pointer, 1, bx + sprite_width + 9, by + 8, 1, 1, 0, 65280, 1);
				break;
		}
	}
	if (!s_is_staff(pos)) {
		if (ds_map_exists(pmap, "kr") && ds_map_find_value(pmap, "kr")) {
			draw_sprite(spr_hof_s, 1, bx + sprite_width - 20, by + 2);
		}
		if (s_is_co_mode() && ds_map_find_value(pmap, "suspended")) {
			draw_sprite(spr_condition, 4, bx + sprite_width - 9, by + 20);
		} else if (ds_map_find_value(pmap, "resting")) {
			draw_sprite(spr_condition, 3, bx + sprite_width - 9, by + 20);
		} else if (!flash_attitude && sin(current_time / 200) > 0.1) {
			if (ds_map_find_value(pmap, "outtrade_pick") > 0) {
				draw_sprite(spr_trade, 0, bx + sprite_width - 9, by + 20);
			} else if (con < 0) {
				draw_sprite(spr_condition, 0, bx + sprite_width - 9, by + 20);
			}
		}
	}
	if (s_is_co_mode()) {
		if (!s_is_staff(pos)) {
			var tmap = ds_list_find_value(obj_master.teamlist, obj_master.myteam_id);
			if (!is_undefined(tmap) && ds_map_find_value(tmap, "type") == "Military") {
				draw_sprite(spr_co_year_military, s_college_age_index(age), bx + 10, by + 19);
			} else {
				draw_sprite(spr_co_year, s_college_age_index(age), bx + 10, by + 19);
			}
		}
	} else if (age == s_rookie_age_internal()) {
		draw_sprite(spr_rookie, 0, bx + 10, by + 19);
	}
} else if (s_is_co_mode()) {
	if (ds_list_find_index(obj_master.roster, pmap) != -1) {
		shader_set(sh_ColorReplaceBlend);
		shader_set_uniform_f(global.colorHelmet, 1, 0, 0);
		shader_set_uniform_f(global.colorShirt, 0, 1, 0);
		shader_set_uniform_f(global.colorPants, 1, 0, 1);
		shader_set_uniform_f(global.replaceHelmet, helmet[2], helmet[1], helmet[0]);
		shader_set_uniform_f(global.replaceShirt, shirt[2], shirt[1], shirt[0]);
		shader_set_uniform_f(global.replacePants, pants[2], pants[1], pants[0]);
		draw_sprite_ext(spr_jacket_black, 0, bx + 17, by + 14, 1, 1, 0, 16777215, 1);
		shader_reset();
	} else if (ds_map_find_value(pmap, "team_leave_reason") == "drafted") {
	} else if (ds_map_find_value(pmap, "team_leave_reason") == "graduated") {
		var skin = ds_map_find_value(pmap, "skin");
		var colSkin = s_get_skin_colour_by_index(skin);
		var col_skin_r = color_get_red(colSkin) / 255;
		var col_skin_g = color_get_green(colSkin) / 255;
		var col_skin_b = color_get_blue(colSkin) / 255;
		shader_set(sh_ColorReplaceBlend);
		shader_set_uniform_f(global.colorSkin, 1, 0, 0);
		shader_set_uniform_f(global.colorCleats, 0, 0, 1);
		shader_set_uniform_f(global.replaceSkin, col_skin_r, col_skin_g, col_skin_b);
		shader_set_uniform_f(global.replaceCleats, min(col_skin_r * 1.2, 1), min(col_skin_g * 1.2, 1), min(col_skin_b * 1.2, 1));
		draw_sprite_ext(spr_gown, 0, bx + 17, by + 14, 1, 1, 0, 16777215, 1);
		shader_reset();
	} else {
		shader_set(sh_ColorReplaceBlend);
		shader_set_uniform_f(global.colorHelmet, 1, 0, 0);
		shader_set_uniform_f(global.colorShirt, 0, 1, 0);
		shader_set_uniform_f(global.colorPants, 1, 0, 1);
		if (ds_map_exists(pmap, "uniform_record") && ds_map_find_value(pmap, "uniform_record") != "") {
			var draftUniform = s_uniform_cols_from_record(ds_map_find_value(pmap, "uniform_record"));
			shader_set_uniform_f(global.replaceHelmet, draftUniform[0], draftUniform[1], draftUniform[2]);
			shader_set_uniform_f(global.replaceShirt, draftUniform[3], draftUniform[4], draftUniform[5]);
			shader_set_uniform_f(global.replacePants, draftUniform[6], draftUniform[7], draftUniform[8]);
		} else {
			shader_set_uniform_f(global.replaceHelmet, helmet[2], helmet[1], helmet[0]);
			shader_set_uniform_f(global.replaceShirt, shirt[2], shirt[1], shirt[0]);
			shader_set_uniform_f(global.replacePants, pants[2], pants[1], pants[0]);
		}
		draw_sprite_ext(spr_jacket_black, 0, bx + 17, by + 14, 1, 1, 0, 16777215, 1);
		shader_reset();
	}
} else {
	draw_sprite_ext(spr_jacket, 0, bx + 17, by + 14, 1, 1, 0, 16777215, 1);
}
draw_set_halign(1);
var tx = bx + sprite_width * 0.5;
var ty = by + 48;
var name = string_copy(ds_map_find_value(pmap, "lname"), 1, 7);
draw_hd_text(tx, ty, name);
ty += 12;
if (s_is_staff(pos)) {
	if (pos != 100 && ds_list_find_index(obj_master.stafflist, pmap) == -1) {
		draw_sprite_ext(spr_star_rating_cb, ds_map_find_value(pmap, "rating"), tx, ty, 1, 1, 0, 65535, 1);
		ty += 11;
		var cost = s_get_coach_cost(pmap);
		var tw = string_hd_width(cost) * 0.5;
		tw += sprite_get_width(spr_credit) * 0.5;
		tx -= sprite_get_width(spr_credit) * 0.5;
		draw_hd_text(tx, ty, cost);
		draw_sprite(spr_credit, 0, tx + tw, ty);
	} else {
		draw_sprite_ext(spr_star_rating_cb, ds_map_find_value(pmap, "rating"), tx, ty + 5, 1, 1, 0, 65535, 1);
		ty += 11;
	}
} else {
	draw_sprite_ext(spr_star_rating_cb, s_get_player_rating(pmap), tx, ty, 1, 1, 0, 65535, 1);
	ty += 11;
	var drawNormalPlayer = obj_master.draft_round > 3 && ds_map_find_value(pmap, "teamid") == obj_master.myteam_id && ds_list_find_index(obj_master.roster, pmap) >= 0;
	if (s_is_co_mode()) {
		if (s_doing_college_draft()) {
			drawNormalPlayer = true;
		}
		if (obj_master.college_admissions_draft_round > 0 && ds_list_find_index(obj_master.roster, pmap) >= 0) {
			drawNormalPlayer = true;
		}
	}
	if (current_room == rm_halloffame_players) {
		draw_hd_text(tx, ty, my_tla);
	} else if (drawNormalPlayer) {
		var cx = x + 2;
		var cy = y + sprite_height - 13;
		var cw = sprite_width - 1;
		var ch = 8;
		var prc = (cw - 4) / 100 * clamp(old_condition, 0, 100);
		if (clicked || !active) {
			cx -= 2;
			cy += 2;
		}
		draw_set_color(16777215);
		if (s_is_ui_selected() && selectflash > 0.5) {
			draw_set_color(s_ui_selected_color());
		}
		draw_rectangle(cx, cy, cx + cw, cy + ch, 0);
		draw_set_color(8421504);
		draw_rectangle(cx + 2, cy + 2, cx + cw - 2, cy + ch, 0);
		if (con <= 0) {
			draw_set_color(0);
			draw_rectangle(cx + 2, cy + 2, cx + 2 + cw - 4, cy + ch, 0);
		} else if (con <= 20) {
			draw_set_color(255);
			if (sin(current_time / 100) > 0.1) {
				draw_rectangle(cx + 2, cy + 2, cx + 2 + prc, cy + ch, 0);
			}
		} else if (con <= 40) {
			draw_set_color(65535);
			draw_rectangle(cx + 2, cy + 2, cx + 2 + prc, cy + ch, 0);
		} else {
			draw_set_color(65280);
			draw_rectangle(cx + 2, cy + 2, cx + 2 + prc, cy + ch, 0);
		}
		draw_set_color(16777215);
	} else {
		if (s_is_co_mode()) {
			if (ds_list_find_index(obj_master.roster, pmap) == -1) {
				if (ds_list_find_index(obj_master.roster, pmap) == -1 && ds_map_find_value(pmap, "rc_cost") > obj_master.recruitment_credits) {
					draw_set_color(255);
				}
				draw_hd_text(tx, ty, "$" + string(ds_map_find_value(pmap, "rc_cost")) + s_str("sla_Thousand"));
			}
		} else {
			if (ds_list_find_index(obj_master.roster, pmap) == -1 && ds_map_find_value(pmap, "salary") > s_get_salary_cap_space()) {
				draw_set_color(255);
			}
			draw_hd_text(tx, ty, "$" + string(ds_map_find_value(pmap, "salary")) + s_str("sla_Million"));
		}
		draw_set_color(16777215);
	}
}
var num_roty = 0;
var num_mvp = 0;
var num_opoy = 0;
var num_dpoy = 0;
var num_rings = 0;
var num_rbmvp = 0;
var lim = 5;
if (s_is_staff(pos)) {
	lim = 10;
}
if (ds_map_exists(pmap, "roty")) {
	num_roty = min(real(ds_map_find_value(pmap, "roty")), 1);
}
if (ds_map_exists(pmap, "mvp")) {
	num_mvp = min(real(ds_map_find_value(pmap, "mvp")), lim);
}
if (ds_map_exists(pmap, "opoy")) {
	num_opoy = min(real(ds_map_find_value(pmap, "opoy")), 1);
}
if (ds_map_exists(pmap, "dpoy")) {
	num_dpoy = min(real(ds_map_find_value(pmap, "dpoy")), lim);
}
if (ds_map_exists(pmap, "rings")) {
	num_rings = min(real(ds_map_find_value(pmap, "rings")), lim);
}
if (ds_map_exists(pmap, "rbmvp")) {
	num_rbmvp = min(real(ds_map_find_value(pmap, "rbmvp")), 1);
}
if (pos == 100) {
	num_rings = min(s_count_achievement("ACH_WIN_RETROBOWL1"), lim);
}
var mx = bx + 3;
var my = by + 26;
if (num_roty) {
	draw_sprite_ext(spr_medals, 0, mx, my, 1, 1, 0, 16777215, 1);
	mx += 8;
}
for (var i = 0; i < num_mvp; i++) {
	draw_sprite_ext(spr_medals, 1, mx, my, 1, 1, 0, 16777215, 1);
	mx += 2;
}
if (num_mvp > 0) {
	mx += 6;
}
for (var i = 0; i < num_opoy; i++) {
	draw_sprite_ext(spr_medals, 2, mx, my, 1, 1, 0, 16777215, 1);
	mx += 2;
}
if (num_opoy > 0) {
	mx += 6;
}
for (var i = 0; i < num_dpoy; i++) {
	draw_sprite_ext(spr_medals, 3, mx, my, 1, 1, 0, 16777215, 1);
	mx += 2;
}
if (num_dpoy > 0) {
	mx += 6;
}
for (var i = 0; i < num_rbmvp; i++) {
	draw_sprite_ext(spr_medals, 4, mx, my, 1, 1, 0, 16777215, 1);
	mx += 2;
}
my += 1;
mx = bx + 50 - (num_rings - 1) * 2;
for (var i = 0; i < num_rings; i++) {
	draw_sprite_ext(spr_sb_ring, 0, mx, my, 1, 1, 0, 16777215, 1);
	mx += 2;
}
