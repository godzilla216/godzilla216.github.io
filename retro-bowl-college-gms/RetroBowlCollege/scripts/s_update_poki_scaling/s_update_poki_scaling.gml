function s_update_poki_scaling() {
	if (global.browser) {
		with (obj_master) {
			if (browser_width != canvaswidth || browser_height != canvasheight) {
				canvaswidth = browser_width;
				canvasheight = browser_height;
				scale_canvas(480, 270, max(480, canvaswidth), max(270, canvasheight), true);
			}
			return;
			if (browser_width != canvaswidth || browser_height != canvasheight) {
				var scl = 4;
				while (scl >= 1) {
					if (browser_height >= 270 * scl) {
						canvaswidth = browser_width;
						canvasheight = browser_height;
						scale_canvas(480, 270, max(480, 480 * scl), max(270, 270 * scl), true);
						return;
					}
					scl -= 0.1;
				}
			}
		}
	}
}

