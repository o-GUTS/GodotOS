extends Control

class_name Terminal

const COMMAND_OUTPUT_LABEL_SCENE: PackedScene = preload("res://Games/Terminal/command_output_label.tscn")

@onready var comand_line: LineEdit = %comand_line
@onready var command_output_container: VBoxContainer = %command_output_container


# Create and append a new CommandOutputLabel to the container
func push_line_to_output(text: String) -> void:
	var new_label: CommandOutputLabel = COMMAND_OUTPUT_LABEL_SCENE.instantiate()
	command_output_container.add_child(new_label)
	new_label.text = text


# Just queue_free all the labels
func clear_output() -> void:
	for child: CommandOutputLabel in command_output_container.get_children():
		child.queue_free()


# Parse the String given by the user, where:
# [command_call_name, arg0, arg1, ...]
# "echo hello world" -> ["echo", "hello", "world"]
# "echo "hello world"" -> ["echo", "hello world"]
func parse_input(input: String) -> Array[String]:
	var parsed_input: Array[String] = []
	
	# Remove all non-printable characters from the edges of the string. 
	input.strip_edges()
	
	var current_substring: String = ""
	var inside_quotes: bool = false
	for input_char: String in input:
		if input_char == '"':
			inside_quotes = not inside_quotes
		elif input_char == ' ' and not inside_quotes:
			parsed_input.append(current_substring)
			current_substring = ""
		else:
			current_substring += input_char
	
	# Appends the last argument
	# Doing here because with no space at the end
	# the last argument is ignored by the loop
	parsed_input.append(current_substring)
	
	return parsed_input


# Called when the user presses enter with the command line in focus
func _on_comand_line_text_submitted(new_text: String) -> void:
	comand_line.clear()
	
	var echo_cmd: TerminalCommand = load("res://Games/Terminal/commands/echo_command.gd").new()
	var parsed_input: Array[String] = parse_input(new_text) 
	var args: Array[String] = parsed_input.slice(1, parsed_input.size())#TEMP slice to remove command_call_name
	echo_cmd.execute(self, args)
