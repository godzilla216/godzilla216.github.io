function poki_btn_click_CoinBoost() {
	slog("poki_btn_click_CoinBoost");
	s_create_message("", s_str("poki_CoinBoostMsg"), s_str("ui_No"), s_str("ui_Yes"), poki_CoinBoost_No, poki_CoinBoost_Yes, global.c_background, 1);
}

function poki_CoinBoost_No() {
	s_msg_clear();
	layer_set_visible(layer_get_id("Poki_Layer"), false);
}

function poki_CoinBoost_Yes() {
	global.poki_done_post_match_reward = true;
	poki_CoinBoost_No();
	poki_pause();
	poki_rewarded_break(_poki_rewarded_ad, "rewarded_break");
}

