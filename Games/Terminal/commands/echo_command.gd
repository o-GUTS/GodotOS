extends TerminalCommand


func _init() -> void:
	call_name = "echo"


func execute(terminal: Terminal, args: Array[String]) -> void:
	#TODO just for testing
	var output: String = ""
	for arg: String in args:
		output += arg + " "
	
	terminal.push_line_to_output(output)
