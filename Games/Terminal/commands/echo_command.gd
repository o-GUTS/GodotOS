extends TerminalCommand


func _init() -> void:
	call_name = "echo"


func execute(terminal: Terminal, args: Array[String]) -> void:
	var output: String = ""
	for arg: String in args:
		output += arg + " "
	
	# Remove all non-printable characters from the edges of the string. 
	output.strip_edges()
	
	terminal.push_line_to_output(output)
