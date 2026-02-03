extends Resource
class_name TerminalCommand

var call_name: String = ""

# Called when the command is instantiated
# Used to setup command properties
func _init() -> void:
	push_error("Not implemented, setup the call_name variable here")

# Called when the user input matches the call_name variable
@warning_ignore("unused_parameter")
func execute(terminal: Terminal, args: Array[String]) -> void:
	push_error("Not implemented, the command main code goes here")
