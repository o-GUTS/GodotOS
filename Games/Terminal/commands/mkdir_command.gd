extends TerminalCommand


func _init() -> void:
	call_name = "mkdir"


func execute(terminal: Terminal, args: Array[String]) -> void:
	var desktop: DesktopFileManager = terminal.get_tree().get_first_node_in_group("desktop_file_manager")
	
	if args.size() == 1:
		desktop.new_folder()
		#TODO change folder name to match arg[0]
		terminal.push_line_to_output("Created new directory named: %s" % [args[0]])
	else:
		terminal.push_line_to_output("Invalid command usage")
