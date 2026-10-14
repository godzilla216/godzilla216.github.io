function s_do_banner_draft() {
	var msg = instance_create_layer(0, 0, "PopUps", obj_match_msg);
	msg.flash = false;
	msg.col = 16777215;
	msg.alarm[0] = 80;
	var txt = s_str("ui_DraftRound");
	txt = string_replace(txt, "$num", string(obj_master.draft_round));
	msg.text = txt;
	obj_master.dodraftbanner = false;
}

function s_do_banner_season_review() {
	var msg = instance_create_layer(0, 0, "PopUps", obj_match_msg);
	msg.flash = false;
	msg.col = 16777215;
	msg.alarm[0] = 80;
	var txt = s_str("ui_SeasonReview");
	txt = string_replace(txt, "$num", string(obj_master.draft_round));
	msg.text = txt;
}

