y -= 0.2;
alpha -= 0.025;
if (img) {
	y -= 0.1;
	imgscl += 0.01;
}
if (alpha <= 0) {
	instance_destroy();
}
