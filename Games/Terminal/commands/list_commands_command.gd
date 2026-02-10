extends TerminalCommand


func _init() -> void:
	call_name = "commands"


func execute(terminal: Terminal, args: Array[String]) -> void:
	if args.size() > 0:
		terminal.push_line_to_output("Invalid command usage")
		return
	
	for cmd_name: String in terminal.command_manager.get_command_call_names():
		terminal.push_line_to_output(cmd_name)
