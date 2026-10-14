function s_create_new_save() {
	slog("s_create_new_save");
	with (obj_master) {
		newslist = ds_list_create();
		list_news_dyn = ds_list_create();
		dilemma_tags = ds_list_create();
		news_tags = ds_list_create();
		teamlist = s_load_teams();
		s_set_teams_min_max_ids();
		achievements = s_load_map_file("Achievements.txt");
		records = s_load_map_file("PlayerRecords.txt");
		history = ds_list_create();
		schedule = s_load_schedule();
		fixturelist = s_create_my_fixture_list();
		playoffs = ds_list_create();
		draftlist = ds_list_create();
		hirelist = ds_list_create();
		storelist = ds_list_create();
		tradelist = ds_list_create();
		freeagentlist = ds_list_create();
		roster = ds_list_create();
		stafflist = ds_list_create();
		hoflist = ds_list_create();
		rbhistorylist = ds_list_create();
		shoppinglist = s_load_map_file("Shopping.txt");
		list_teams_rejected = ds_list_create();
		face_grid_L = ds_grid_create(8, 3);
		face_grid_M = ds_grid_create(8, 1);
		face_grid_D = ds_grid_create(8, 8);
		face_grid_C = ds_grid_create(9, 4);
		ds_grid_clear(face_grid_L, 0);
		ds_grid_clear(face_grid_M, 0);
		ds_grid_clear(face_grid_D, 0);
		ds_grid_clear(face_grid_C, 0);
		if (s_is_co_mode() == false) {
			s_create_new_roster();
		}
		s_create_new_stafflist();
		cap_breach_flag = -1;
		do_welcome_msg = true;
	}
}

function s_regen_clean_save_mode_dependent_data() {
	with (obj_master) {
		s_destroy_map_file(teamlist);
		teamlist = s_load_teams();
		s_set_teams_min_max_ids();
		if (s_is_co_mode()) {
			s_load_co_mode_files();
			slog("SETTING INITIAL TEAM RANKING");
			s_co_reset_teams_rank();
			s_subdivision_update_rankings(1);
			s_subdivision_update_rankings(2);
			slog("RELOADING SCHEDULE");
			s_destroy_map_file(schedule);
			schedule = s_load_schedule();
			slogf("schedule size: %1", ds_list_size(schedule));
			s_destroy_map_file(fixturelist);
			fixturelist = s_create_my_fixture_list();
		}
	}
	s_create_new_roster();
	s_create_new_stafflist();
}

function s_load_co_mode_files() {
	with (obj_master) {
		if (variable_instance_exists(id, "hobbies") == false || hobbies == -1) {
			hobbies = s_load_map_file("Hobbies_CO.txt");
		}
		if (variable_instance_exists(id, "majorminor") == false || majorminor == -1) {
			majorminor = s_load_map_file("MajorMinor_CO.txt");
		}
		if (variable_instance_exists(id, "cities") == false || cities == -1) {
			cities = s_load_map_file("Cities_CO.txt");
		}
		if (variable_instance_exists(id, "traits") == false || traits == -1) {
			traits = s_load_map_file("Traits_CO.txt");
		}
		if (variable_instance_exists(id, "epilogue") == false || epilogue == -1) {
			epilogue = s_load_map_file("EpilogueValues_CO.txt");
		}
	}
}

