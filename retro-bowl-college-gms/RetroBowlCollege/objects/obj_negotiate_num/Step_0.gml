var des_scl = max(0, 2 - abs(position * 0.4));
scl = lerp(scl, des_scl, 0.1);
var buf = 78 - abs(position * 5.5);
var desx = 240 + buf * position;
x = lerp(x, desx, 0.1);
y = 144;
