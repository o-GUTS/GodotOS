extends TerminalCommand


func _init() -> void:
	call_name = "help"


func execute(terminal: Terminal, args: Array[String]) -> void:
	if args.size() == 0 or args.size() > 1:
		terminal.push_line_to_output(
			"Invalid number of arguments, expected 1, found %s." % [args.size()]
		)
		return
	
	var command_call_name: String = args[0]
	if !terminal.command_manager.cmd_exists(command_call_name):
		terminal.push_line_to_output("%s not found." % [command_call_name])
		return
	
	terminal.push_lines_to_output(
		terminal.command_manager.load_command(command_call_name).usage()
	)


func usage() -> Array[String]:
	return [
		"Help - Prints a command usage information.",
		"USAGE:",
		"Takes one argument.",
		"If given argument is a valid command call_name",
		"push it's usage info line by line to the terminal."
	]
