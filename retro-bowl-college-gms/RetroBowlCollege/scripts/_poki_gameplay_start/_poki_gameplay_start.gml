function _poki_gameplay_start() {
	if (global.poki && !global.poki_gameplay) {
		slog("_poki_gameplay_start");
		poki_gameplay_start();
		global.poki_gameplay = true;
	}
}

