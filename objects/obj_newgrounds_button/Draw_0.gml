draw_self();
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var txt = "sync with\nleaderboards"
if (was_clicked) {
	txt = "waiting for\nlogin..."
}
draw_set_font(sys.small_font);
draw_text_transformed(x, y, txt, sys.browser_scale, sys.browser_scale, 0);
draw_set_font(sys.big_font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);