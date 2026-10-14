event_inherited();
if (!global.IAP_Enabled) {
	active = false;
	obj_master.alarm[0] = room_speed * 10;
}
if (obj_master.intro) {
	visible = false;
}
if (!global.mobile_device || 0) {
	instance_destroy();
}
