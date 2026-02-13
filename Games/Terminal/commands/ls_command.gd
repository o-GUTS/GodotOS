extends TerminalCommand


func _init() -> void:
	call_name = "ls"


func execute(terminal: Terminal, args: Array[String]) -> void:
	if args.size() > 0:
		terminal.push_line_to_output("Invalid usage")
		return
	
	for directory: String in terminal.virtual_path_manager.list_directories():
		terminal.push_line_to_output(directory)
	
	for file: String in terminal.virtual_path_manager.list_files():
		terminal.push_line_to_output(file)
