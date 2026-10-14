function s_get_random_charity() {
	var file = file_text_open_read("Charities.txt");
	var names;
	var num = 0;
	while (!file_text_eof(file)) {
		file_text_readln(file);
		var n = file_text_read_string(file);
		names[num++] = n;
	}
	file_text_close(file);
	return names[irandom(num - 1)];
}

