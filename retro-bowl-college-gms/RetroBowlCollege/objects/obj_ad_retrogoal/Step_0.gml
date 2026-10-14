if (mouse_check_button_released(1)) {
	switch (os_type) {
		case 3:
			switch (ds_map_find_value(obj_master.map_options, "done_ad_retrogoal") mod 6) {
				case 0:
					url_open_ext(global.url_switch_us, "_blank");
					break;
				case 1:
					url_open_ext(global.url_apple_gp, "_blank");
					break;
				case 2:
					url_open_ext(global.url_apple_retrogoal, "_blank");
					break;
				case 3:
					url_open_ext(global.url_apple_nss, "_blank");
					break;
				case 4:
					url_open_ext(global.url_apple_nsb, "_blank");
					break;
				case 5:
					url_open_ext(global.url_apple_nsm, "_blank");
					break;
			}
			break;
		case 4:
		case 0:
			switch (ds_map_find_value(obj_master.map_options, "done_ad_retrogoal") mod 6) {
				case 0:
					url_open_ext(global.url_switch_us, "_blank");
					break;
				case 1:
					url_open_ext(global.url_google_gp, "_blank");
					break;
				case 2:
					url_open_ext(global.url_google_retrogoal, "_blank");
					break;
				case 3:
					url_open_ext(global.url_google_nss, "_blank");
					break;
				case 4:
					url_open_ext(global.url_google_nsb, "_blank");
					break;
				case 5:
					url_open_ext(global.url_google_nsm, "_blank");
					break;
			}
			break;
	}
	room_goto(rm_home);
}
