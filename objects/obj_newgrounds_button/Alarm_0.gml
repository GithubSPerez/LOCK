update_active(true);
if (sys.is_logged_in()) {
	update_active();
	obj_game.post_highscore();
}
else {
	alarm[0] = 60;
}
