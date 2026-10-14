var _x = 24;
var _y = 52;
var skn = 0;
var fx = 0;
var fy = 0;
var fcount = 0;
var bcount = 0;
var max_count = 96;
var face_set = 0;
if (obj_master.face_type_coach) {
	max_count = 36;
}
if (s_is_co_mode() && obj_master.face_type_coach == false) {
	face_set = 1;
	max_count = 192;
}
max_pages = ceil(max_count / 24);
obj_master.face_page = clamp(obj_master.face_page, 1, max_pages);
inst_100057.text = s_str("ui_Page") + " " + string(obj_master.face_page) + " / " + string(max_pages);
for (var pg = 0; pg < max_pages; pg++) {
	for (var r = 0; r < 4; r++) {
		for (var i = 0; i < 6; i++) {
			if (obj_master.face_page - 1 == pg && fcount < max_count) {
				btn[bcount] = instance_create_layer(_x, _y, "Instances", obj_headshot);
				_x += 73;
				btn[bcount].skin = skn;
				btn[bcount].face_x = fx;
				btn[bcount].face_y = fy;
				btn[bcount].onClickAction = btn_click_ChooseFaceDone;
				btn[bcount].coach_heads = obj_master.face_type_coach;
				btn[bcount].face_set = face_set;
				bcount++;
			}
			fx++;
			fcount++;
			switch (obj_master.face_type_coach) {
				case 0:
					if (fx > 7) {
						fx = 0;
						fy++;
					}
					break;
				case 1:
					if (fx > 8) {
						fx = 0;
						fy++;
					}
					break;
			}
			if (fcount == 64) {
				skn = 1;
				fx = 0;
				fy = 0;
			}
			if (fcount == 72) {
				skn = 2;
				fx = 0;
				fy = 0;
			}
			if (s_is_co_mode()) {
				if (fcount == 96) {
					fx = 0;
					fy = 0;
					face_set = 2;
					skn = 0;
				}
				if (fcount == 160) {
					skn = 1;
					fx = 0;
					fy = 0;
				}
				if (fcount == 168) {
					skn = 2;
					fx = 0;
					fy = 0;
				}
			}
		}
		if (obj_master.face_page - 1 == pg) {
			_x = 24;
			_y += 48;
		}
	}
}
with (obj_headshot) {
	if (face_x == -1) {
		instance_destroy();
	}
}
s_find_default_button(true);
