function s_open_store_nag() {
	s_open_store();
	if (!global.IAP_Enabled) {
		return;
	}
}

