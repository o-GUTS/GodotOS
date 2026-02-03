extends TerminalCommand


func _init() -> void:
	call_name = "cls"


func execute(terminal: Terminal, args: Array[String]) -> void:
	terminal.clear_output()
