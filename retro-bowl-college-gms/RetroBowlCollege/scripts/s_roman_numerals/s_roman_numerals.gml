function s_roman_numerals(_arg0) {
	values[0] = 1000;
	values[1] = 900;
	values[2] = 500;
	values[3] = 400;
	values[4] = 100;
	values[5] = 90;
	values[6] = 50;
	values[7] = 40;
	values[8] = 10;
	values[9] = 9;
	values[10] = 5;
	values[11] = 4;
	values[12] = 1;
	numerals[0] = "M";
	numerals[1] = "CM";
	numerals[2] = "D";
	numerals[3] = "CD";
	numerals[4] = "C";
	numerals[5] = "XC";
	numerals[6] = "L";
	numerals[7] = "XL";
	numerals[8] = "X";
	numerals[9] = "IX";
	numerals[10] = "V";
	numerals[11] = "IV";
	numerals[12] = "I";
	var number = _arg0;
	if (number < 0 || number > 3999) {
		return "";
	}
	var str = "";
	for (var i = 0; i < 13; i++) {
		while (number >= values[i]) {
			number -= values[i];
			str += numerals[i];
		}
	}
	return str;
}

