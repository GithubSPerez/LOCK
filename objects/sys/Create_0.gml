one = 0.1;
last_one = 0.1;

big_font = font_add_sprite_ext(spr_big_font, "abcdefghijklmnopqrstuvwxyz1234567890*/'\",.:", true, -1);
big_font_mono = font_add_sprite_ext(spr_big_font, "abcdefghijklmnopqrstuvwxyz1234567890*/'\",.:", false, -1);
small_font = font_add_sprite_ext(spr_font, "abcdefghijklmnopqrstuvwxyz0123456789.:", true, -1);

orientation = -1;
l_orientation = -1;

shake_index = {};
shake_ids = [];
shake_timer = 0;

game_width = 640;
game_height = 360;

gui_width = game_width * 2;
gui_height = game_height * 2;

window_width = 1280;
window_height = 720;

on_browser = os_browser != browser_not_a_browser

browser_scale = 1280 / 960;

if (on_browser) {
	window_width = 960
	window_height = 540
}

update_screen = function() {
	var cam = view_get_camera(0);
	switch orientation {
		case "horizontal":
			display_set_gui_size(gui_width, gui_height);
			window_set_size(window_width, window_height);
			camera_set_view_size(cam, game_width, game_height);
			view_set_wport(0, window_width);
			view_set_hport(0, window_height);
			
			surface_resize(application_surface, window_width, window_height);
		break;
		
		case "vertical":
			display_set_gui_size(gui_height, gui_width);
			window_set_size(window_height * 0.75, window_width * 0.75);
			camera_set_view_size(cam, game_height, game_width);
			view_set_wport(0, window_height);
			view_set_hport(0, window_width);
			
			surface_resize(application_surface, window_height, window_width);
		break;
	}
	alarm[0] = 1;
}

shake = function(shake_id) {
	if (struct_exists(shake_index, shake_id)) {
		return shake_index[$ shake_id];
	}
	return {angle: 0, intensity: 0, slow_factor: 0};
}

shake_init = function(shake_id, intensity, slow_factor) {
	if (!struct_exists(shake_index, shake_id)) {
		shake_index[$ shake_id] = {angle: 0, intensity: intensity, slow_factor: slow_factor};
		array_push(shake_ids, shake_id);
	}
}

shake_step_all = function() {
	for (var i = 0; i < array_length(shake_ids); i++) {
		shake_step(shake_ids[i]);
	}
}

shake_step = function(shake_id) {
	var shk = shake(shake_id);
	var ang = random(360);
	while (abs(angle_difference(ang, shk.angle)) <= 45) ang = random(360);
	shk.angle = ang;
	shk.intensity -= shk.slow_factor;
	if (shk.intensity < 0) shk.intensity = 0;
}


shakeX = function(shake_id) {
	var shk = shake(shake_id);
	return dcos(shk.angle) * shk.intensity;
}

shakeY = function(shake_id) {
	var shk = shake(shake_id);
	return dsin(shk.angle) * shk.intensity;
}

shake_set = function(shake_id, intensity) {
	var shk = shake(shake_id);
	shk.intensity = intensity;
}

random_set_seed(date_current_datetime());

NG = {
	app_id: "",
	app_key: "",
	board_id: ""
}

var env = load_env();

if (env != undefined) {
	NG.app_id = env.ng.app_id;
	NG.app_key = env.ng.app_key;
	NG.board_id = env.ng.board_id;
}

ng_connect(NG.app_id, NG.app_key);
ng_initialize_medals_and_scoreboard();

is_logged_in = function () {
	var name = ng_get_username();
	if (string(name) != "") {
		return true;
	}
	return false;
}



if (on_browser) {
	room_goto(rm_browser);
}
else {
	room_goto(rm_game);
}