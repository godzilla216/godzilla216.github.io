if (y > ground) {
	alf -= 0.01;
	speed = 0;
	if (alf < 0) {
		instance_destroy();
	}
} else {
	dstep += 5;
	direction = -90 - 10 * (0.5 + dcos(dstep));
	y2 = y - 25;
	y3 = y + 50;
	x2 = x - 250;
	x3 = x + 250;
	x4 = x - 500;
	x5 = x + 500;
}
