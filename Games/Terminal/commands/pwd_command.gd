extends TerminalCommand


func _init() -> void:
	call_name = "pwd"


func execute(terminal: Terminal, args: Array[String]) -> void:
	if args.size() > 0:
		terminal.push_line_to_output("Invalid command usage")
		return
	
	terminal.push_line_to_output(
		terminal.virtual_path_manager.get_path()
	)
