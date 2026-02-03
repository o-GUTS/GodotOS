extends TerminalCommand


func _init() -> void:
	call_name = "cls"


func execute(terminal: Terminal, _args: Array[String]) -> void:
	terminal.clear_output()
