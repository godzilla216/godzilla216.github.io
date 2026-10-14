function _poki_rewarded_ad(_arg0, _arg1) {
	slog("_poki_rewarded_ad");
	if (_arg1 == "rewarded_break") {
		if (_arg0) {
			var cx1 = inst_100482.x + inst_100482.sprite_width * 0.16;
			var cx2 = inst_100482.x + inst_100482.sprite_width * 0.5;
			var cx3 = inst_100482.x + inst_100482.sprite_width * 0.82;
			var cy = inst_100482.y + inst_100482.sprite_height * 0.5;
			var dx = inst_100483.x + inst_100483.sprite_width * 0.5;
			var dy = inst_100483.y + inst_100483.sprite_height * 0.5;
			var coins = 1;
			s_create_credit(cx1, cy, dx, dy, 1, 1, -4, true);
			if (obj_master.fans > 33) {
				coins = 2;
				s_create_credit(cx2, cy, dx, dy, 1, 1, -4, false);
			}
			if (obj_master.fans > 66) {
				coins = 3;
				s_create_credit(cx3, cy, dx, dy, 1, 1, -4, false);
			}
			ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + coins);
			obj_master.season_credits_purchased += coins;
			audio_play_sound(snd_purchase, 1, false);
		}
	}
	poki_resume();
}

