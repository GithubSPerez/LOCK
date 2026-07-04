function get_leaderboards() {
	var wscores = ng_getScores(sys.NG.app_id, sys.NG.board_id, 10, "W", 0, false);
	var tscores = ng_getScores(sys.NG.app_id, sys.NG.board_id, 10, "A", 0, false);
	
	return {
		week: wscores,
		all_time: tscores
	}
}