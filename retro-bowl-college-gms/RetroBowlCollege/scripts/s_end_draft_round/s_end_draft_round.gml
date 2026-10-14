function s_end_draft_round(_arg0) {
	slog("s_end_draft_round");
	with (obj_master) {
		switch (draft_round) {
			case 1:
				while (ds_list_size(draftlist) > 35) {
					var i = irandom(5);
					ds_map_destroy(ds_list_find_value(draftlist, i));
					ds_list_set(draftlist, i, -1);
					ds_list_delete(draftlist, i);
				}
				break;
			case 2:
				while (ds_list_size(draftlist) > 20) {
					var i = irandom(5);
					ds_map_destroy(ds_list_find_value(draftlist, i));
					ds_list_set(draftlist, i, -1);
					ds_list_delete(draftlist, i);
				}
				break;
			case 3:
				var size = ds_list_size(draftlist);
				if (size > draft_picks[2] * 2) {
					var i = irandom(size - 1);
					ds_map_destroy(ds_list_find_value(draftlist, i));
					ds_list_set(draftlist, i, -1);
					ds_list_delete(draftlist, i);
				}
				break;
		}
		draft_picks[draft_round - 1] = 0;
		draft_round++;
		draft_page = 1;
		if (_arg0) {
			draft_round = 4;
		}
		if (draft_round > 3) {
			s_destroy_draftlist();
			s_add_news(s_str("news_DraftEnded"));
			stage = 1;
			room_goto(rm_home);
		} else if (!qb_mode) {
			dodraftbanner = true;
			room_goto(rm_draft);
		}
	}
}

function s_destroy_draftlist() {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(draftlist); i++) {
			ds_map_destroy(ds_list_find_value(draftlist, i));
			ds_list_set(draftlist, i, -1);
		}
		ds_list_clear(draftlist);
	}
	s_reset_draft_picks();
}

