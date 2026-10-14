if (global.poki) {
	instance_destroy();
	exit;
}
if (global.browser) {
	if (google) {
		sprite_index = spr_app_google;
	}
} else if (google) {
	sprite_index = spr_app_discord;
} else {
	sprite_index = spr_app_twitter;
}
