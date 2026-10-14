function s_update_rest_all_button() {
	with (obj_master) {
		if (stage == 7 || qb_mode) {
			inst_100628.visible = false;
		} else {
			inst_100628.visible = true;
			inst_100628.text = s_str("btn_RestAll");
			if (s_all_players_resting()) {
				inst_100628.text = s_str("btn_UnrestAll");
			}
		}
	}
}

