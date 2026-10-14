function btn_click_BuyMerch() {
	url_open_ext(global.url_merch_tshirts, "_blank");
}

function btn_click_MusicBy() {
	url_open_ext(global.url_heatley_bros, "_blank");
}

function btn_click_YouTube() {
	url_open_ext(global.url_jefe_zhai, "_blank");
}

function btn_click_RecordBook() {
	url_open_ext(global.url_record_book, "_blank");
}

function btn_click_Leagues() {
	url_open_ext(global.url_leagues, "_blank");
}

function btn_click_ad_NSS() {
	switch (os_type) {
		case 3:
			url_open_ext(global.url_apple_nss, "_blank");
			break;
			break;
		case 4:
		case 0:
			url_open_ext(global.url_google_nss, "_blank");
			break;
			break;
	}
}

function btn_click_ad_NSM() {
	switch (os_type) {
		case 3:
			url_open_ext(global.url_apple_nsm, "_blank");
			break;
			break;
		case 4:
		case 0:
			url_open_ext(global.url_google_nsm, "_blank");
			break;
			break;
	}
}

function btn_click_ad_RG() {
	switch (os_type) {
		case 3:
			url_open_ext(global.url_apple_retrogoal, "_blank");
			break;
			break;
		case 4:
		case 0:
			url_open_ext(global.url_google_retrogoal, "_blank");
			break;
			break;
	}
}

function btn_click_ad_NSB() {
	switch (os_type) {
		case 3:
			url_open_ext(global.url_apple_nsb, "_blank");
			break;
			break;
		case 4:
		case 0:
			url_open_ext(global.url_google_nsb, "_blank");
			break;
			break;
	}
}

function btn_click_ad_RB() {
	switch (os_type) {
		case 3:
			url_open_ext(global.url_apple_retrobowl, "_blank");
			break;
			break;
		case 4:
		case 0:
			url_open_ext(global.url_google_retrobowl, "_blank");
			break;
			break;
	}
}

function btn_click_ad_GP() {
	switch (os_type) {
		case 3:
			url_open_ext(global.url_apple_gp, "_blank");
			break;
			break;
		case 4:
		case 0:
			url_open_ext(global.url_google_gp, "_blank");
			break;
			break;
	}
}

function btn_click_NewStarGames() {
	url_open_ext("https://www.newstargames.com", "_blank");
}

