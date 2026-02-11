extends TerminalCommand


func _init() -> void:
	call_name = "cat"


func execute(terminal: Terminal, args: Array[String]) -> void:
	if args.size() > 1:
		terminal.push_line_to_output("Invalid command usage")
		return
	
	var file_path: String = "user://files/" + args[0]
	
	if FileAccess.file_exists(file_path):
		var file := FileAccess.open(file_path, FileAccess.READ)
		var file_text: PackedStringArray = file.get_as_text().split("\n")
		
		for line: String in file_text:
			terminal.push_line_to_output(line)
	
	else:
		terminal.push_line_to_output("File not found")
