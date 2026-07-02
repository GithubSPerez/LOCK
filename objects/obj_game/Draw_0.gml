var cam = view_get_camera(0);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

var separate = 3;
var chunk = size + separate * 2;
var total_slices = floor(((2 * pi * radius) / chunk) / (chunk / 2)) * (chunk / 2);
var back_slices = (2 * pi * (radius + size)) / size;
var angle_diff = radtodeg((2 * pi) / total_slices);
var back_angle_diff = radtodeg((2 * pi) / back_slices);

coin_scale += (coin_scale - 1)

var draw_open = function(i, angle_diff, radius, spd, x_center, y_center, scale, op, ind) {
	var ang = i * angle_diff + ((game_angle * spd) / 2);
	draw_sprite_ext(spr_open, ind, x + x_center + dcos(ang) * radius + sys.shakeX("circle"), y + y_center - dsin(ang) * radius  + sys.shakeY("circle"), scale, scale, ang, c_white, op);
}



var whoo = 10;
var get_op = function(j, whoo) {
	 return power((j / whoo), clamp(200 / clamp(score - 15, 1, score), 0, 100));
}
for (var j = 1; j <= whoo; j ++) {
	var x_center = 4*(whoo - j) * dcos((game_angle + j * 2) );
	var y_center = 4*(whoo - j) * dsin((game_angle + j * 2) );
	var op = get_op(j, whoo);
	for (var i = 0; i < back_slices; i++) {
		
		draw_open(i, back_angle_diff, radius * j / whoo, whoo / j, x_center, -y_center, j / whoo, op, 1);
	}

	for (var i = 0; i < total_slices; i++) {
		draw_open(i, angle_diff, radius * j / whoo, whoo / j, x_center, -y_center, j / whoo, op, 0);
	}
}

draw_sprite_ext(spr_ojo, 0, x + 40 * dcos(game_angle), y - 40 * dsin(game_angle), 1, 1, 0, c_white, get_op(1, whoo));


draw_sprite_ext(spr_coin, 0, x + dcos(target_angle) * coin_radius + sys.shakeX("circle"), y - dsin(target_angle) * coin_radius + sys.shakeY("circle"), 1, 1, 0, c_yellow, (clamp(coin_timer / 5, 0, 1)));

// Draw thing
var draw_thing = function(ang, op) {
	draw_sprite_ext(spr_thing, 0, x + dcos(ang) * thing_radius + sys.shakeX("thing"), y - dsin(ang) * thing_radius + sys.shakeY("thing"), 1, 1, ang, c_white, op);
}

var gang = prev_frame_angle;
var gdir = sign(angle_difference(game_angle, gang));

var aDiff = function(gang) {
	return angle_difference(game_angle, gang);
}

var ogDiff = aDiff(gang);

while aDiff(gang) * gdir > 0 {
	draw_thing(gang, 1 - (aDiff(gang) / ogDiff));
	gang += gdir;
}

draw_thing(game_angle, 1);



/*
draw_line(x, y, x + dcos(game_angle - angle_window) * 1000, y - dsin(game_angle - angle_window) * 1000)
draw_line(x, y, x + dcos(game_angle + angle_window) * 1000, y - dsin(game_angle + angle_window) * 1000)

draw_set_color(c_red);
draw_line(x, y, x + dcos(game_angle - min_angle_diff) * 1000, y - dsin(game_angle - min_angle_diff) * 1000)
draw_line(x, y, x + dcos(game_angle + min_angle_diff) * 1000, y - dsin(game_angle + min_angle_diff) * 1000)
draw_set_color(c_white);
*/

if (hideUI) {
	return
}
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(sys.big_font_mono);
if (botted) {
	draw_set_color(c_red);
}
draw_text_transformed(x - sys.shakeX("thing"), y - 16 - sys.shakeY("thing"), score, 3, 3, 0);
draw_set_color(c_white);
draw_set_font(sys.big_font);



switch state {
	case st.wait:
		// Draw quick options
		var cx = x;
		var cy = cam_h - options_offset - 8;
		draw_text(cx, cy - 24, "volume");
		draw_sprite_ext(spr_bar, 0, cx, cy, 10, 1, 0, c_white, 1);
		draw_sprite(spr_bar, 1, cx + (audio_get_master_gain(0) - 0.5) * size * 10, cy);
		
		draw_sprite(spr_bar, 1 + play_music, 16, cam_h - options_offset);
		draw_set_halign(fa_left);
		draw_text(32, cam_h - options_offset, "music");
		draw_set_halign(fa_center);
		break;
	case st.game_over:
		draw_text_transformed(x + sys.shakeY("circle"), y + 32 + sys.shakeX("circle"), "game over", 2, 2, 0);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);