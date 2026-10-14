function _poki_gameplay_stop() {
	if (global.poki && global.poki_gameplay) {
		slog("_poki_gameplay_stop");
		poki_gameplay_stop();
		global.poki_gameplay = false;
	}
}

