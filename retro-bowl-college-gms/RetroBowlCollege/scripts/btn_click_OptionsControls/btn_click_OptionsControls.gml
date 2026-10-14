function btn_click_OptionsControls() {
	room_goto(rm_options_mapping);
}

function btn_click_OptionsControls1() {
	s_update_control_screen(1);
}

function btn_click_OptionsControls2() {
	s_update_control_screen(2);
}

function btn_click_OptionsControls3() {
	s_update_control_screen(3);
}

function s_update_control_screen(_arg0) {
	inst_100648.colour = global.c_background;
	inst_100649.colour = global.c_background;
	inst_100650.colour = global.c_background;
	with (obj_text) {
		instance_destroy();
	}
	switch (_arg0) {
		case 1:
			inst_100648.colour = global.c_primary;
			break;
		case 2:
			inst_100649.colour = global.c_primary;
			break;
		case 3:
			inst_100650.colour = global.c_primary;
			break;
	}
	var c1 = array_create(9);
	var c2 = array_create(9);
	var c3 = array_create(9);
	for (var i = 0; i < 9; i++) {
		c1[i] = instance_create_layer(200, 48 + i * 20, "Instances", obj_text);
		c1[i].draw_box = false;
		c1[i].halign = 2;
		c2[i] = instance_create_layer(280, 48 + i * 20, "Instances", obj_text);
		c2[i].draw_box = false;
		c2[i].halign = 1;
		c3[i] = instance_create_layer(400, 48 + i * 20, "Instances", obj_text);
		c3[i].draw_box = false;
		c3[i].halign = 1;
		c1[i].text = s_str("Map_Tab" + string(_arg0) + "_Line" + string(i + 1) + "_L");
		c2[i].text = s_str("Map_Tab" + string(_arg0) + "_Line" + string(i + 1) + "_B1");
		c3[i].text = s_str("Map_Tab" + string(_arg0) + "_Line" + string(i + 1) + "_B2");
	}
	with (obj_text) {
		if (string_count("@", text)) {
			visible = false;
		}
	}
}

