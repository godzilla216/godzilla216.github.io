var rs = obj_weather.rain_speed;
var w = obj_weather.wind;
var wd = obj_weather.wind_dir;
switch (wd) {
	case 0:
		hspeed = w * 0.1;
		break;
	case 1:
		hspeed = w * 0.05;
		break;
	case 2:
		hspeed = 0;
		break;
	case 3:
		hspeed = w * -0.05;
		break;
	case 4:
		hspeed = w * -0.1;
		break;
	case 5:
		hspeed = w * -0.05;
		break;
	case 6:
		hspeed = 0;
		break;
	case 7:
		hspeed = w * 0.05;
		break;
}
hspeed = 0;
splash = false;
im = 1;
var sp = random_range(0.1, 1);
vspeed = rs * (sp + 0.5);
ground = 66 + 468 * sp;
if (ground > 150) {
	im = 2;
}
y2 = y - 25;
y3 = y + 50;
x2 = x - 250;
x3 = x + 250;
x4 = x - 500;
x5 = x + 500;
image_xscale = 2;
image_yscale = 2;
