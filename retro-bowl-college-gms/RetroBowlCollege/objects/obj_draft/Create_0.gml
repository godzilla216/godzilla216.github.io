profile[5] = obj_player_profile;
slog("obj_draft");
var picks = 0;
with (obj_master) {
	picks = draft_picks[draft_round - 1];
	if (obj_master.co_mode == 0) {
		if (picks == 0) {
			s_end_draft_round(false);
			exit;
		}
	}
	draftlist = s_sort_players(draftlist, 2);
	switch (draft_info_done) {
		case 0:
			s_do_info("info_Draft");
			draft_info_done = 2;
			break;
		case 1:
			s_do_info("info_Draft2");
			draft_info_done = 2;
			break;
		case 2:
			break;
	}
}
inst_100059.text = string_replace(s_str("ui_DraftRound"), "$num", string(obj_master.draft_round));
inst_100061.text = s_str("ui_Picks");
if (s_is_co_mode()) {
	inst_100061.visible = false;
}
page_max = ceil(ds_list_size(obj_master.draftlist) / 10);
if (page_max < 1) {
	page_max = 1;
}
obj_master.draft_page = clamp(obj_master.draft_page, 1, page_max);
s_update_draft_page();
if (obj_master.dodraftbanner) {
	s_do_banner_draft();
}
