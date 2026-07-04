if (hideUI) {
	return
}
draw_text_transformed(8, 8, "highscore: " + string(highscore), 3, 3, 0);

draw_set_halign(fa_center);
if (show_click_message) {
	draw_text_transformed(display_get_gui_width() / 2, display_get_gui_height() * 0.65, "press space or click to play", 3, 3, 0)
}
draw_set_halign(fa_left);