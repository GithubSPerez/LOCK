function load_env(){
	if (!file_exists("env.json")) {
		show_message("env file is missing");
		return undefined;
	}
	
	var f = file_text_open_read("env.json");
	var json = "";
	while (!file_text_eof(f)) {
		json += file_text_readln(f);
	}
	return json_parse(json);
}