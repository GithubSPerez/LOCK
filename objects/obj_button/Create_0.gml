is_hovering = function() {
	if (collision_circle(mouse_x, mouse_y, 4, id, true, false)) {
		return true;
	}
	return false;
}