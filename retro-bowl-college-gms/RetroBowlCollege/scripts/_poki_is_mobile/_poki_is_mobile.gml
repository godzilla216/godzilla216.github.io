function _poki_is_mobile() {
	slog("_poki_is_mobile");
	if (os_type == 4 || os_type == 3) {
		return true;
	}
	return false;
}

