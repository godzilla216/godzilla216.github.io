function s_goto_room(_arg0, _arg1) {
	if (_arg1 == undefined) {
		_arg1 = {};
	}
	global.rm_params = _arg1;
	room_goto(_arg0);
}

function s_init_rm() {
	global.rm = self;
	slogf("\n*** INIT ROOM %1", room_get_name(current_room));
	if (variable_global_exists("rm_params")) {
		array_foreach(variable_struct_get_names(global.rm_params), function(_arg0, _arg1) {
			slogf("rm_params %1: %2 = %3", _arg1, _arg0, variable_struct_get(global.rm_params, _arg0));
			variable_instance_set(global.rm, _arg0, variable_struct_get(global.rm_params, _arg0));
		});
	}
	action_destroy = s_destroy_rm;
}

function s_destroy_rm() {
	global.rm_params = {};
	global.rm = -4;
}

function s_create_title(_arg0, _arg1, _arg2) {
	if (_arg1 == undefined) {
		_arg1 = 16;
	}
	if (_arg2 == undefined) {
		_arg2 = false;
	}
	return instance_create_layer(240, _arg1, global.rm.layer, obj_roomtitle, { text: _arg0, show_stars: _arg2 });
}

function s_create_button(_arg0, _arg1, _arg2, _arg3) {
	if (_arg3 == undefined) {
		_arg3 = obj_button_9s;
	}
	return instance_create_layer(_arg0, _arg1, id.layer, _arg3, _arg2);
}

function s_destroy_dynamic_buttons(_arg0) {
	array_foreach(_arg0, function(_arg0, _arg1) {
		instance_destroy(_arg0);
	});
}

function s_calc_grid_coords(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7) {
	if (_arg1 == undefined) {
		_arg1 = [];
	}
	if (_arg2 == undefined) {
		_arg2 = 25;
	}
	if (_arg3 == undefined) {
		_arg3 = 75;
	}
	if (_arg4 == undefined) {
		_arg4 = 4;
	}
	if (_arg5 == undefined) {
		_arg5 = 110;
	}
	if (_arg6 == undefined) {
		_arg6 = 38;
	}
	if (_arg7 == undefined) {
		_arg7 = true;
	}
	var grid = [];
	var groups_num = array_length(_arg1);
	var cur_break = 0;
	var group_cnt;
	var cnt;
	var oy = 0;
	for (var k = 0; k < groups_num + 1; k++) {
		if (cur_break < groups_num) {
			group_cnt = _arg1[cur_break];
		} else {
			group_cnt = _arg0;
		}
		for (var i = 0; i < group_cnt; i++) {
			if (i < group_cnt - group_cnt mod _arg4 || group_cnt mod _arg4 == 0 || !_arg7) {
				cnt = 0;
			} else {
				cnt = (_arg4 - group_cnt mod 4) * _arg5 / 2;
			}
			array_push(grid, { x: _arg2 + (i mod 4) * _arg5 + cnt, y: _arg3 + oy + floor(i / 4) * _arg6 });
		}
		cur_break++;
		_arg0 -= group_cnt;
		oy += _arg6;
	}
	return grid;
}

function s_show_rm_winners(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5) {
	obj_master.rm_winners_do_awards = _arg0;
	obj_master.rm_winners_cid = _arg1;
	obj_master.rm_winners_tier = _arg2;
	obj_master.rm_winners_custom = _arg3;
	if (_arg5) {
		s_sound_brass_loop(1);
	}
	s_goto_room(rm_winners, { click_continue: _arg4 });
}

