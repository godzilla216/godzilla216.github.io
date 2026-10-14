function s_get_random_last_name() {
	var file = file_text_open_read("Names_L.txt");
	var names;
	var num = 0;
	while (!file_text_eof(file)) {
		file_text_readln(file);
		var n = file_text_read_string(file);
		if (string_length(n) < 8) {
			names[num++] = n;
		}
	}
	file_text_close(file);
	return names[irandom(num - 1)];
}

