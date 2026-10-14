function s_show_backups() {
	s_msg_clear();
	with (obj_master) {
		var bg = instance_create_layer(0, 0, "PopUps", obj_msgbg);
		bg.colour = global.c_background;
		bg.alpha = 1;
		var title = instance_create_layer(display_get_gui_width() * 0.5, 32, "PopUps", obj_roomtitle);
		title.text = s_str("ui_RestoreSave");
		title.show_stars = true;
		title.depth = bg.depth - 1;
		var btn_store_exit = instance_create_layer(8, 232, "PopUps", obj_button_sqr);
		btn_store_exit.image = spr_arrowL;
		btn_store_exit.onClickAction = s_msg_clear;
		btn_store_exit.depth = bg.depth - 1;
		var by = 52;
		var bh = 36;
		for (var i = 1; i < 6; i++) {
			vbox_iap[i] = instance_create_layer(80, by, "PopUps", obj_vbox);
			vbox_iap[i].image_xscale = 1.3;
			vbox_iap[i].image_yscale = 0.25;
			vbox_iap[i].depth = bg.depth - 1;
			vbox_iap[i].title = "";
			btn_iap[i] = instance_create_layer(294, by, "PopUps", obj_button);
			btn_iap[i].depth = bg.depth - 1;
			btn_iap[i].text = "Restore";
			btn_iap[i].active = false;
			var backup_name = "backup_";
			switch (i) {
				case 1:
					backup_name += global.g_savename1;
					btn_iap[i].onClickAction = s_restore_backup1;
					break;
				case 2:
					backup_name += global.g_savename2;
					btn_iap[i].onClickAction = s_restore_backup2;
					break;
				case 3:
					backup_name += global.g_savename3;
					btn_iap[i].onClickAction = s_restore_backup3;
					break;
				case 4:
					backup_name += global.g_savename4;
					btn_iap[i].onClickAction = s_restore_backup4;
					break;
				case 5:
					backup_name += global.g_savename5;
					btn_iap[i].onClickAction = s_restore_backup5;
					break;
			}
			if (file_exists(backup_name)) {
				vbox_iap[i].text = s_get_string_save_details(i, true);
				btn_iap[i].active = true;
			}
			by += bh;
		}
	}
}

function s_restore_backup1() {
	if (file_exists("backup_" + global.g_savename1)) {
		if (file_exists(global.g_savename1)) {
			file_delete(global.g_savename1);
		}
		file_copy("backup_" + global.g_savename1, global.g_savename1);
		s_msg_clear();
		btn_click_slot(1, global.g_savename1, true);
	}
}

function s_restore_backup2() {
	if (file_exists("backup_" + global.g_savename2)) {
		if (file_exists(global.g_savename2)) {
			file_delete(global.g_savename2);
		}
		file_copy("backup_" + global.g_savename2, global.g_savename2);
		s_msg_clear();
		btn_click_slot(2, global.g_savename2, true);
	}
}

function s_restore_backup3() {
	if (file_exists("backup_" + global.g_savename3)) {
		if (file_exists(global.g_savename3)) {
			file_delete(global.g_savename3);
		}
		file_copy("backup_" + global.g_savename3, global.g_savename3);
		s_msg_clear();
		btn_click_slot(3, global.g_savename3, true);
	}
}

function s_restore_backup4() {
	if (file_exists("backup_" + global.g_savename4)) {
		if (file_exists(global.g_savename4)) {
			file_delete(global.g_savename4);
		}
		file_copy("backup_" + global.g_savename4, global.g_savename4);
		s_msg_clear();
		btn_click_slot(4, global.g_savename4, true);
	}
}

function s_restore_backup5() {
	if (file_exists("backup_" + global.g_savename5)) {
		if (file_exists(global.g_savename5)) {
			file_delete(global.g_savename5);
		}
		file_copy("backup_" + global.g_savename5, global.g_savename5);
		s_msg_clear();
		btn_click_slot(5, global.g_savename5, true);
	}
}

