radius = 100;
coin_radius = radius + 40;
size = 16;
thing_radius = radius + size * 1.25;

slider = false;

options_offset = 16;

x = room_width / 2;
y = room_height / 2;
game_start_speed = 1.2;
game_accel = 0.05;
score = 0;
angle_window = 10;
enum st {
	wait,
	play,
	game_over
}

min_angle_diff = 3.5 * angle_window;
slowmo_time = 20;
score_scale = 30;
state_timer = 0;

var f = ini_open("record.ini")
highscore = ini_read_real("record", "highscore", 0);
audio_set_master_gain(0, ini_read_real("options", "volume", 0.25));
play_music = ini_read_real("options", "music", true);
ini_close();

audio_sound_loop_start(mus_lock, 14.382);

speaker = noone;
pre_music = true;

get_music_asset = function() {
	if (pre_music) return mus_happyland;
	return mus_lock;
}

pre_music_start_pitch = 0.75;
pre_music_play_pitch = 0.8;

checkpoint = 15;
reached_checkpoint = false;

botted = false;

advance_game_angles = function(change = 240) {
	lock_direction *= -1;
		
	last_angle = target_angle;
	target_angle = next_target;
	
	while (abs(angle_difference(target_angle, next_target)) < min_angle_diff) {
		var r = change;
		if ((score <= 50) and (abs(score - 50) <= 5)) r = min_angle_diff * 2;
		var rchange = random_range(0, r)
		next_target += rchange * -lock_direction;
	}
}


init_variables = function() {
	passing = false;
	pass_multiplier = 1;
	state = st.wait;
	last_angle = 0;
	slowmo = 1;
	
	game_angle = 90;
	prev_frame_angle = game_angle;
	game_speed = game_start_speed;
	
	lock_direction = -1;
	target_angle = game_angle;
	next_target = game_angle;
	
	repeat 2 advance_game_angles(90);
	
	afterimage_timer = 0;
	afterimage_angle = game_angle;
	
	close_calls = 0;
	speed_index = 0;
	
	beat_index = 0;
	beat_score = 0;
	
	coin_scale = 0;
	coin_timer = 0;

	score = 0;
}

onBeat = function () {
	if (pre_music) {
		if (beat_score < score) {
			beat_score++;
			if (speaker != noone) {
				audio_sound_pitch(speaker, pre_music_play_pitch + (1 - pre_music_play_pitch) * (beat_score / checkpoint));
			}
		}
	}
}

init_variables();

sys.shake_init("thing", 0, 0.5);
sys.shake_init("circle", 0, 0.3);

hideUI = false;

show_click_message = true;
