extends TerminalCommand


func _init() -> void:
	call_name = "mkdir"


func execute(terminal: Terminal, args: Array[String]) -> void:
	if args.size() > 0:
		terminal.push_line_to_output(
			"Invalid number of arguments, expected 0, found %s." % [args.size()]
		)
		return
	
	var desktop: DesktopFileManager = terminal.get_tree().get_first_node_in_group("desktop_file_manager")
	desktop.new_folder()
	
	#TODO change new folder name to match arg[0]
	terminal.push_line_to_output("Created new directory in root.")


func usage() -> Array[String]:
	return [
		"Mkdir - Make directory.",
		"USAGE:",
		"Takes no arguments.",
		"Creates a new folder in the root directory."
	]
