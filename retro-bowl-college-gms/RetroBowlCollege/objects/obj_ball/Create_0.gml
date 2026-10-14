event_inherited();
state = 0;
holder = s_get_quarterback();
last_touched_by = -4;
x = holder.x;
y = holder.y;
xtouch = 0;
ytouch = 0;
touch_starty = 250;
dragdist = 0;
dragx = 0;
dragy = 0;
xthrow = 0;
ythrow = 0;
is_dead = false;
xdead = 0;
ydead = 0;
height = 1;
lastheight = height;
last_x = 0;
last_y = 0;
xreceived = 0;
yreceived = 0;
bullet_throw = 0;
bullet_throw_hold = false;
direc = 0;
if (obj_controller.drivedir == -1) {
	direc = 180;
}
velocity = 0;
zvel = 0;
roll = 0;
rotation = 0;
bouncecount = 0;
dropped_time = 0;
fumble_time = 0;
goaldirec = 0;
kickflip = 1;
kickpow = 0;
kicky = 300 + irandom_range(-100, 100);
kickx = 2510;
cpu_kickpow = irandom_range(38.5, 55);
image_speed_previous = image_speed;
if (obj_controller.drivedir == -1) {
	kickx = 90;
	goaldirec = 180;
}
if (obj_controller.kicking) {
	kickpow = 20;
}
if (s_cpu_is_kicking_off()) {
	switch (kickx) {
		case 90:
			kickx = 2510;
			break;
		case 2510:
			kickx = 90;
			break;
	}
}
my_shadow = layer_sprite_create(layer_get_id("Shadows"), x, y, spr_ball);
layer_sprite_blend(my_shadow, 0);
layer_sprite_alpha(my_shadow, 0.2);
for (var i = 0; i < 20; i++) {
	l_blur[i][0] = 0;
	l_blur[i][1] = 0;
}
switch (obj_master.op_ball) {
	case 0:
		sprite_index = spr_ball1;
		break;
	case 1:
		sprite_index = spr_ball2;
		break;
	case 2:
		sprite_index = spr_ball3;
		break;
	case 3:
		sprite_index = spr_ball4;
		break;
	case 4:
		sprite_index = spr_ball5;
		break;
	case 5:
		sprite_index = spr_ball6;
		break;
}
