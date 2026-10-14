function s_get_string_picks(_arg0) {
	var short = _arg0;
	var draft_txt = "";
	var spacer = " - ";
	if (short) {
		spacer = "-";
	}
	with (obj_master) {
		draft_txt += string(draft_picks[0]) + spacer;
		draft_txt += string(draft_picks[1]) + spacer;
		draft_txt += string(draft_picks[2]);
	}
	return draft_txt;
}

