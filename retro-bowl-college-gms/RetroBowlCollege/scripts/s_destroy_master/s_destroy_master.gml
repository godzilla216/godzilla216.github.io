function s_destroy_master() {
	with (obj_master) {
		ds_map_destroy(map_options);
		map_options = -1;
		for (var i = 0; i < ds_list_size(teamlist); i++) {
			ds_map_destroy(ds_list_find_value(teamlist, i));
		}
		for (var i = 0; i < ds_list_size(achievements); i++) {
			ds_map_destroy(ds_list_find_value(achievements, i));
		}
		for (var i = 0; i < ds_list_size(records); i++) {
			ds_map_destroy(ds_list_find_value(records, i));
		}
		for (var i = 0; i < ds_list_size(history); i++) {
			ds_map_destroy(ds_list_find_value(history, i));
		}
		for (var i = 0; i < ds_list_size(schedule); i++) {
			ds_map_destroy(ds_list_find_value(schedule, i));
		}
		for (var i = 0; i < ds_list_size(fixturelist); i++) {
			ds_map_destroy(ds_list_find_value(fixturelist, i));
		}
		for (var i = 0; i < ds_list_size(playoffs); i++) {
			ds_map_destroy(ds_list_find_value(playoffs, i));
		}
		for (var i = 0; i < ds_list_size(draftlist); i++) {
			ds_map_destroy(ds_list_find_value(draftlist, i));
		}
		for (var i = 0; i < ds_list_size(hirelist); i++) {
			ds_map_destroy(ds_list_find_value(hirelist, i));
		}
		for (var i = 0; i < ds_list_size(storelist); i++) {
			ds_map_destroy(ds_list_find_value(storelist, i));
		}
		for (var i = 0; i < ds_list_size(tradelist); i++) {
			ds_map_destroy(ds_list_find_value(tradelist, i));
		}
		for (var i = 0; i < ds_list_size(freeagentlist); i++) {
			ds_map_destroy(ds_list_find_value(freeagentlist, i));
		}
		for (var i = 0; i < ds_list_size(roster); i++) {
			ds_map_destroy(ds_list_find_value(roster, i));
		}
		for (var i = 0; i < ds_list_size(stafflist); i++) {
			ds_map_destroy(ds_list_find_value(stafflist, i));
		}
		ds_list_destroy(newslist);
		ds_list_destroy(list_news_dyn);
		ds_list_destroy(dilemma_tags);
		ds_list_destroy(news_tags);
		ds_list_destroy(teamlist);
		ds_list_destroy(achievements);
		ds_list_destroy(records);
		ds_list_destroy(history);
		ds_list_destroy(schedule);
		ds_list_destroy(fixturelist);
		ds_list_destroy(playoffs);
		ds_list_destroy(draftlist);
		ds_list_destroy(hirelist);
		ds_list_destroy(storelist);
		ds_list_destroy(tradelist);
		ds_list_destroy(freeagentlist);
		ds_list_destroy(roster);
		ds_list_destroy(stafflist);
		ds_list_destroy(hoflist);
		ds_list_destroy(rbhistorylist);
		ds_list_destroy(curriculum_tags);
		if (s_is_co_mode()) {
			slog("s_destroy_CO_FILES");
			s_destroy_map_file(hobbies);
			hobbies = -1;
			s_destroy_map_file(majorminor);
			majorminor = -1;
			s_destroy_map_file(cities);
			cities = -1;
			s_destroy_map_file(traits);
			traits = -1;
			s_destroy_map_file(epilogue);
			epilogue = -1;
		}
		newslist = -1;
		list_news_dyn = -1;
		dilemma_tags = -1;
		news_tags = -1;
		teamlist = -1;
		achievements = -1;
		records = -1;
		history = -1;
		schedule = -1;
		fixturelist = -1;
		playoffs = -1;
		draftlist = -1;
		hirelist = -1;
		storelist = -1;
		tradelist = -1;
		freeagentlist = -1;
		roster = -1;
		stafflist = -1;
		hoflist = -1;
		rbhistorylist = -1;
		curriculum_tags = -1;
		instance_destroy();
	}
}

