visible = active;
if (!active) {
	return;
}

image_blend = c_white;

if (was_clicked) {
	image_blend = c_gray;
	return;
}

if (is_hovering()) {
	image_blend = c_ltgray;
	
	if (mouse_check_button_pressed(mb_left)) {
		if (sys.NG.app_id = "") {
			show_message("environment json missing");
		}
		
		ng_request_login();
		was_clicked = true;
		alarm[0] = 60;
	}
}