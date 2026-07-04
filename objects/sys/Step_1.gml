last_one = one;
one = (delta_time / 1000000) / 0.016;

shake_timer += one;
var shake_frames = 3;
while (shake_timer > shake_frames) {
	shake_timer -= shake_frames;
	shake_step_all();
}

if (keyboard_check_pressed(ord("F"))) {
	if (orientation == "horizontal") {
		orientation = "vertical";
	}
	else {
		orientation = "horizontal";
	}
}

var get_orientation = function() {
	if (os_type == os_android || os_type == os_ios) {
		return display_get_orientation()
	}
	else if (on_browser) {
		if (browser_width < browser_height) {
			return display_portrait
		}
		return display_landscape
	}
	else {
		return noone
	}
}

switch get_orientation() {
	case display_landscape:
	case display_landscape_flipped:
		orientation = "horizontal";
	break;
	
	case display_portrait:
	case display_portrait_flipped:
		orientation = "vertical";
	break;
}

if (orientation != l_orientation) {
	update_screen();
	alarm[1] = 10;
}

l_orientation = orientation;

if (keyboard_check(vk_control) && keyboard_check_pressed(ord("U"))) {
	var name = ng_get_username();

	show_message("user: " + string(name));
}