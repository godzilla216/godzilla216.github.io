function s_aim_AI_defense() {
	if (s_is_kickoff(true)) {
		return s_aim_AI_kickoff();
	}
	var ball = global.master_ball;
	var cont = obj_controller;
	switch (position) {
		case 6:
			var qb = -4;
			with (obj_playerOF) {
				if (position == 1) {
					qb = id;
				}
			}
			if (qb) {
				jforce = 1;
				jdir = point_direction(x, y, qb.x, qb.y);
			} else {
				jforce = 0;
			}
			break;
		case 9:
			if (ball.state == 3 && bouncedist < 80) {
				jdir = point_direction(x, y, obj_metaball.bounce_x, obj_metaball.bounce_y);
				jforce = clamp(bouncedist / 40, 0.25, 0.75);
			} else {
				jdir = 180;
				if (facing == -1) {
					jdir = 0;
				}
				jforce = 0.3;
				var opp = s_get_nearest_opponent_by_position(id, 4);
				if (cont.defensive_cover > 0 || (opp && point_distance(x, y, opp.x, opp.y)) < 80) {
					if (opp) {
						s_cover_object(opp, 1);
						jforce = 0.5;
					}
				}
			}
			break;
		case 8:
		case 7:
			if (ball.state == 3 && bouncedist < 100) {
				jdir = point_direction(x, y, obj_metaball.bounce_x, obj_metaball.bounce_y);
				jforce = clamp(bouncedist / 40, 0.25, 0.75);
			} else if (cont.defensive_cover == 0 && cont.down == 6 && randyards mod 2 == 0) {
				position = 9;
			} else if (cont.defensive_cover == 0 && position == 8 && randyards mod 2 == 0) {
				position = 9;
			} else {
				var opp = nearest_opp;
				if (position == 7) {
					with (obj_playerOF) {
						if (position == 2) {
							opp = id;
						}
					}
					var closest_dist = 0;
					var closest_lb = -4;
					with (obj_playerDF) {
						var dist = point_distance(x, y, opp.x, opp.y);
						if (!closest_lb || dist < closest_dist) {
							closest_dist = dist;
							closest_lb = id;
						}
					}
					if (closest_lb != id) {
						opp = nearest_opp;
						if (cont.defensive_cover == 0) {
							with (obj_playerOF) {
								if (position == 1) {
									opp = id;
								}
							}
						}
					}
				} else if (!opp) {
					if (position == 8) {
						opp = s_get_nearest_opponent_by_position(id, 4);
					}
					if (position == 7) {
						opp = s_get_nearest_opponent_by_position(id, -4);
					}
				}
				if (opp && !opp.tackling && opp.position != 5) {
					var diff = clamp(obj_controller.difficulty, 1, 10) / 10;
					var d = lerp(10, 40, diff);
					var oppdist = point_distance(x, y, opp.x, opp.y);
					if (ball.holder != opp.id && oppdist > d) {
						s_cover_object(opp, lerp(0.25, 0.5, diff));
						jforce = 1;
					} else if (opp.position != 1 && !s_opponent_goalside(opp)) {
						var oppdist = point_distance(x, y, opp.x, opp.y);
						jforce = clamp(oppdist / 20, 0.5, 1);
					} else {
						s_intercept_object(opp);
					}
				} else if (position == 7) {
					switch (randyards mod 2) {
						case 0:
							jdir = 180;
							if (facing == -1) {
								jdir = 0;
							}
							jforce = 0.25;
							break;
						default:
							jforce = 0.75;
							var opp = -4;
							switch (facing) {
								case -1:
									jdir = 180;
									if (x < cont.x_scrim) {
										opp = s_get_nearest_opponent_by_position(id, 1);
									}
									break;
								case 1:
									jdir = 0;
									if (x > cont.x_scrim) {
										opp = s_get_nearest_opponent_by_position(id, 1);
									}
							}
							if (opp) {
								s_intercept_object(opp);
							}
							break;
					}
				}
			}
			break;
	}
}

