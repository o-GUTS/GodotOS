extends Control

class_name Terminal

const COMMAND_OUTPUT_LABEL_SCENE: PackedScene = preload("res://Games/Terminal/command_output_label.tscn")

@onready var comand_line: LineEdit = %comand_line
@onready var command_output_container: VBoxContainer = %command_output_container


func _on_comand_line_text_submitted(new_text: String) -> void:
	var new_label: CommandOutputLabel = COMMAND_OUTPUT_LABEL_SCENE.instantiate()
	command_output_container.add_child(new_label)
	new_label.text = new_text
	
	comand_line.clear()
