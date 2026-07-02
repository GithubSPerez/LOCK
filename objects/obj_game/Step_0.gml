var cam = view_get_camera(0);

var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

x = camera_get_view_x(cam) + camera_get_view_width(cam) / 2;
y = camera_get_view_y(cam) + camera_get_view_height(cam) / 2;

options_offset = 16;
if (sys.orientation == "vertical") options_offset = 140;

var one = sys.one;
var click = keyboard_check_pressed(vk_space) or mouse_check_button_pressed(mb_left);
var click_held = mouse_check_button(mb_left);
var click_released = mouse_check_button_released(mb_left);

var lstate = state;
state_timer += one;
coin_timer += one;

prev_frame_angle += (game_angle - prev_frame_angle) * (1 - power(0.3, one));

if (speaker != noone) {
	var interval = beat_second_interval(get_music_asset());
	var actual_beat = ceil(audio_sound_get_track_position(speaker) / interval);
	if (actual_beat != beat_index) {
		beat_index = actual_beat
		onBeat();
	}
}

var lose_game = function() {
	state = st.game_over;
	ini_open("record.ini");
	ini_write_real("record", "highscore", highscore);
	ini_close();
	window_mouse_set_locked(false);
	window_set_cursor(cr_arrow);
	
	audio_play_sound(snd_lose, 1, false);
	sys.shake_set("thing", 5);
	sys.shake_set("circle", 3);
	
	if (speaker != noone) {
		if (pre_music) {
		audio_stop_sound(speaker);
		speaker = noone;
		}
		else {
			audio_sound_gain(speaker, 0, 3000);
		}
	}
}

var manage_music = function(play_sound = true) {
	if (play_sound) {
		var hitsound = snd_coin;
		if (lock_direction == -1) hitsound = snd_kick;
		audio_sound_pitch(audio_play_sound(hitsound, 1, false), 1 + random_range(-0.05, 0.05));
	}
	
	if (!play_music) return;
	
	if (score >= checkpoint) {
		if (speaker == noone || pre_music) {
			audio_sound_pitch(speaker, 1);
			if (speaker != noone) audio_stop_sound(speaker);
			speaker = audio_play_sound(mus_lock, 1, true);
			pre_music = false;
		}
	}
	else {
		if (pre_music) {
			if (score == checkpoint - 1) audio_sound_gain(speaker, 0, 2000);
		}
	}
}

var speed_up = function(n = 1) {
	repeat n {
		if (speed_index % ((floor(speed_index / score_scale)) + 1) == 0) {
			game_speed += game_accel;
		}
		speed_index++;
	}
}

switch state {
	case st.wait:
		if (slider or (abs(mouse_x - x) < 100 and mouse_y > cam_h - options_offset - 24 and mouse_y < cam_h - options_offset + 24)) {
			
			if (click_held) {
				audio_set_master_gain(0, clamp(0.5 + (mouse_x - x) / 160, 0, 1))
				slider = true;
			}
			
			if (click or click_released) {
				audio_play_sound(snd_fireball, 1, false);
				ini_open("record.ini");
				ini_write_real("options", "volume", audio_get_master_gain(0));
				ini_close();
				slider = false;
			}
		}
		else if (mouse_x < 48 and mouse_y > cam_h - options_offset - 24 and mouse_y < cam_h - options_offset + 24) {
			if (click) {
				play_music = !play_music;
				if (play_music) audio_play_sound(snd_dragon_coin, 1, false);
				else audio_play_sound(snd_fireball, 1, false);
				ini_open("record.ini");
				ini_write_real("options", "music", play_music);
				ini_close();
			}
		}
		else {
			if (click) {
				state = st.play;
				show_click_message = false;
				window_mouse_set_locked(true);
				window_set_cursor(cr_none);
			
				var play_pre_music = function () {
					speaker = audio_play_sound(mus_happyland, 1, true);
					pre_music = true;
					audio_sound_pitch(speaker, pre_music_start_pitch);
				}
				
				if (play_music) {
			
					if (speaker == noone) {
						play_pre_music();
					}
					else {
						if (audio_sound_get_gain(speaker) <= 0) {
							audio_stop_sound(speaker);
							speaker = noone;
							play_pre_music();
						}
						else {
							audio_sound_gain(speaker, 1, 1000);
						}
					}
					
					manage_music(false);
				}
			}
		}
		break;
	case st.play:
		if (slowmo > 0) {
			slowmo -= one / 2;
		}
		var slowmo_factor = 1 - (slowmo / slowmo_time);
		
		var lgame_angle = prev_frame_angle;
		game_angle += game_speed * lock_direction * one * slowmo_factor * pass_multiplier;
		
		if (slowmo > 0) {
			slowmo -= one / 2;
		}
		

		var thing_mark_1 = prev_frame_angle;
		var thing_mark_2 = game_angle;
			
		var target_mark_1 = target_angle - angle_window;
		var target_mark_2 = target_angle + angle_window;
			
		if (angle_difference(thing_mark_2, thing_mark_1) < 0) {
			thing_mark_1 = game_angle;
			thing_mark_2 = prev_frame_angle;
		}
			
		var in_angle = (
			angle_in_range(thing_mark_1, target_mark_1, target_mark_2) or
			angle_in_range(thing_mark_2, target_mark_1, target_mark_2) or
			angle_in_range(target_mark_1, thing_mark_1, thing_mark_2) or
			angle_in_range(target_mark_2, thing_mark_1, thing_mark_2)
		)

		if (in_angle) {
			if (!passing) passing = true;
			if (botted) click = true;
		}
		else {
			if (passing) {
				//lose_game();
				if (speed_index < 999) {
					if (game_speed * pass_multiplier < 46)
					{
						pass_multiplier ++;
						audio_stop_sound(snd_blargg);
						audio_play_sound(snd_blargg, 1, false);
						sys.shake_set("thing", 5);
					}
				}
				passing = false;
			}
		}
		
		var aDiff = angle_difference(afterimage_angle, prev_frame_angle);
		if (aDiff != 0) {
			while (abs(aDiff) > 8) {
				afterimage_angle += 8 * -sign(aDiff);
				if (abs(angle_difference(target_angle, next_target)) < min_angle_diff * 2) {
					var ang = afterimage_angle;
					instance_create_layer(x + dcos(ang) * thing_radius, y - dsin(ang) * thing_radius, layer_get_id("afterimage"), obj_afterimage).image_angle = ang;
				}
				
				aDiff = angle_difference(afterimage_angle, prev_frame_angle);
			}
		}
		
			
		if (click) {
			if (in_angle) {
				speed_up(1);
				score++;
				coin_timer = 0;
				
				manage_music();
				
				if (score > highscore and !botted) highscore = score;
				if (score >= checkpoint) reached_checkpoint = true;
				passing = false;
				
				instance_create_layer(x + dcos(target_angle) * (coin_radius + size), y - dsin(target_angle) * (coin_radius + size), "afterimage", obj_coin, {image_angle: target_angle});
				advance_game_angles();
				
				if (abs(angle_difference(target_angle, last_angle)) < min_angle_diff * 2) {
					if (close_calls > 0) {
						with obj_afterimage {
							spd = 12;
						}
						
						with obj_coin {
							spd = 5;
							image_index = 0;
						}
					}
					else close_calls++;
					
					slowmo = slowmo_time;
				}
				else {
					close_calls = 0;
				}
			}
			else {
				lose_game();
			}
			
		}
		
		break;
		
	case st.game_over:
		if (keyboard_check_pressed(ord("R")) or (state_timer > 10 and click)) {
			init_variables();
			if (reached_checkpoint) {
				score = checkpoint;
				speed_up(checkpoint);
			}
		}
	break;
}

if (lstate != state) state_timer = 0;