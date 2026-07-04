is_hovering = function() {
	if (collision_circle(mouse_x, mouse_y, 4, id, true, false)) {
		return true;
	}
	return false;
}

active = false;
was_clicked = false;

update_active = function(loading = false) {
	if (!sys.on_browser) {
		active = false;
		return;
	}
	
	if (sys.is_logged_in()) {
		active = false;
		
		return;
	}
	else if (!loading) {
		if (was_clicked) {
			was_clicked = false;
			alarm[0] = -1;
		}
	}
	
	if (obj_game.state != st.wait) {
		active = false;
		return;
	}
	
	active = true;
}

update_active();

image_speed = 0;