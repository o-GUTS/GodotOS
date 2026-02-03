extends Control

class_name Terminal

const COMMAND_OUTPUT_LABEL_SCENE: PackedScene = preload("res://Games/Terminal/command_output_label.tscn")
const COMMANDS_DIR: String = "res://Games/Terminal/commands/"

@onready var comand_line: LineEdit = %comand_line
@onready var command_output_container: VBoxContainer = %command_output_container

# All the commands are loaded on opening the terminal
# and stored here, indexed by its call_name
var commands: Dictionary[String, TerminalCommand] = {}


func _ready() -> void:
	load_all_commands()


# Iterate over the commands folder, filtering out all
# non command resources, and then, storing the founded
# ones in the commands dictionary
func load_all_commands() -> void:
	var commands_folder_contents: PackedStringArray = ResourceLoader.list_directory(COMMANDS_DIR)
	
	for cmd_path: String in commands_folder_contents:
		# Skips the base TerminalCommand file:
		if cmd_path == "terminal_command.gd":
			continue
		
		# Picks just GDScript files, ignoring other types and folders
		if cmd_path.ends_with(".gd"):
			var cmd: Resource = load(COMMANDS_DIR + cmd_path).new()
			if cmd is TerminalCommand:
				commands.set(cmd.call_name, cmd)


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
func parse_input(input: String) -> ParserOutput:
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
	
	return ParserOutput.new(
		parsed_input[0],
		parsed_input.slice(1, parsed_input.size())# Get rid of the first element, the command_call_name
	)


# Called when the user presses enter with the command line in focus
func _on_comand_line_text_submitted(new_text: String) -> void:
	comand_line.clear()
	
	var parsed_input: ParserOutput = parse_input(new_text)
	if commands.has(parsed_input.command_call_name):
		var cmd: TerminalCommand = commands.get(parsed_input.command_call_name)
		cmd.execute(self, parsed_input.command_args)
	else:
		#TODO handle command not found
		pass


class ParserOutput:
	var command_call_name: String
	var command_args: Array[String]
	
	func _init(call_name: String, args: Array[String]) -> void:
		command_call_name = call_name
		command_args = args
