extends TerminalCommand


func _init() -> void:
	call_name = "cd"


func execute(terminal: Terminal, args: Array[String]) -> void:
	if args.size() > 1:
		terminal.push_line_to_output("Invalid usage")
		return
	
	elif args.size() == 0:
		terminal.virtual_path_manager.set_path("")
		return
	
	elif args[0] == "..":
		terminal.virtual_path_manager.set_path(
			terminal.virtual_path_manager.get_base_dir()
		)
		return
	
	var current_path: String = terminal.virtual_path_manager.get_path()
	if current_path != "" and current_path[-1] != '/':
		current_path += '/'
	
	var folder_path: String = current_path + args[0]
	if terminal.virtual_path_manager.path_is_valid_folder(folder_path):
		terminal.virtual_path_manager.set_path(folder_path)
	else:
		terminal.push_line_to_output(folder_path + " is not a folder or do not exist")
