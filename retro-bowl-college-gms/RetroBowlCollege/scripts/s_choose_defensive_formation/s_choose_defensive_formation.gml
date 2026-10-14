function s_choose_defensive_formation() {
	with (obj_controller) {
		defensive_cover = irandom(3);
		var dist = 4;
		if (yards < 8) {
			dist = 3;
		}
		if (yards <= 4) {
			dist = 2;
		}
		if (yards < 2) {
			dist = 1;
		}
		var d43 = 2;
		var blitz = 1;
		var c1 = 1;
		var c4 = 1;
		switch (down) {
			case 1:
				break;
			case 2:
				switch (dist) {
					case 1:
					case 2:
						d43 = 1;
						blitz = 1;
						c1 = 7;
						c4 = 1;
						break;
					case 3:
						d43 = 4;
						blitz = 1;
						c1 = 4;
						c4 = 1;
						break;
					case 4:
						d43 = 4;
						blitz = 1;
						c1 = 4;
						c4 = 1;
						break;
				}
				break;
			case 3:
			case 4:
				switch (dist) {
					case 1:
						d43 = 1;
						blitz = 2;
						c1 = 6;
						c4 = 1;
						break;
					case 2:
						d43 = 5;
						blitz = 3;
						c1 = 1;
						c4 = 1;
						break;
					case 3:
						d43 = 4;
						blitz = 3;
						c1 = 1;
						c4 = 2;
						break;
					case 4:
						d43 = 3;
						blitz = 4;
						c1 = 1;
						c4 = 4;
						break;
				}
				break;
			case 6:
				d43 = 1;
				blitz = 5;
				c1 = 1;
				c4 = 1;
				break;
			default:
				break;
		}
		var playcallroll = random_range(0, d43 + blitz + c1 + c4);
		slog("playcallroll = " + string(playcallroll));
		defensive_cover = 2;
		if (playcallroll > d43) {
			defensive_cover = 0;
		}
		if (playcallroll > d43 + blitz) {
			defensive_cover = 1;
		}
		if (playcallroll > d43 + blitz + c1) {
			defensive_cover = 3;
		}
	}
}

