function s_do_review_message() {
	var msg = s_str("msg_StoreReview");
	msg = string_replace(msg, "$num", string(5));
	ds_map_set(obj_master.map_options, "done_review_reward", 1);
	s_create_message("", msg, s_str("ui_No"), s_str("ui_Yes"), btn_response_review_no, btn_response_review_yes, global.c_background, 1);
}

