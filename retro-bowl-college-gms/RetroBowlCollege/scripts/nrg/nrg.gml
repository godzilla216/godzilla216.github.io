function btn_click_nrg_buy() {
	with (obj_master) {
		qb_nrg++;
	}
	s_savegame();
	room_goto(room);
}

function btn_click_nrg_drink() {
	if (obj_master.qb_nrg > 0) {
		if (s_get_qb_energy() > 50) {
			s_create_message("", s_str("msg_NRG_ConfirmDrink"), s_str("ui_Yes"), s_str("ui_Cancel"), s_drink_nrg, s_msg_clear, global.c_background, 1);
		} else {
			s_drink_nrg();
		}
	} else {
		s_msg(s_str("msg_NRG_NoCans"));
	}
}

function s_drink_nrg() {
	s_msg_clear();
	obj_master.qb_nrg--;
	s_sound(snd_drink);
	var qb = s_get_qb_pmap();
	ds_map_set(qb, "condition", clamp(ds_map_find_value(qb, "condition") + 100, 1, 100));
	s_qb_mode_update_resting();
	s_savegame();
	room_goto(room);
}

function s_get_condition_colour(_arg0, _arg1) {
	if (_arg0 <= 40) {
		return 255;
	} else if (_arg0 <= 60) {
		return 65535;
	} else {
		return _arg1;
	}
}

function s_get_condition_icon(_arg0) {
	if (ds_map_find_value(_arg0, "resting")) {
		return 3;
	} else if (ds_map_find_value(_arg0, "condition") <= 0) {
		return 0;
	} else if (ds_map_find_value(_arg0, "condition") < 40) {
		return 1;
	} else if (ds_map_find_value(_arg0, "condition") < 60) {
		return 2;
	} else {
		return -1;
	}
}

