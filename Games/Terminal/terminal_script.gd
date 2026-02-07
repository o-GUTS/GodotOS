extends Control

class_name Terminal

const COMMAND_OUTPUT_LABEL_SCENE: PackedScene = preload("res://Games/Terminal/command_output_label.tscn")
const COMMANDS_DIR: String = "res://Games/Terminal/commands/"
const MAX_INPUT_HISTORY_SIZE: int = 10

@onready var command_line: LineEdit = %command_line
@onready var command_output_container: VBoxContainer = %command_output_container
@onready var scroll_container: ScrollContainer = %scroll_container

# All the commands are loaded on opening the terminal
# and stored here, indexed by its call_name
var commands: Dictionary[String, TerminalCommand] = {}

# A custom queue to store the user input history
# it follows 3 rules:
# - new input is appended to the front
# - overflow input is removed from the back
# - the first element is the current text in the command_line when the user starts to navigate history
var input_history: Array[String] = [""]
var _input_history_index: int = 0


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
	
	update_scroll()


# Append the new input to the front, don't interfering with the reserved first element
# if greater than MAX_INPUT_HISTORY_SIZE, removes the last element
func push_input_to_history(input: String) -> void:
	# Index 1 to not change the reserved first place
	input_history.insert(1, input)
	
	if input_history.size() > MAX_INPUT_HISTORY_SIZE:
		input_history.pop_back()
	
	# Sets to zero, so the next history navigation
	# can start in the right place 
	_input_history_index = 0


# Returns the value in input_history[_input_history_index]
# and updates the history index
func get_input_in_history(go_up: bool) -> String:
	# If user is starting the history navigation then sets the
	# first element on the array to the current text in the command_line
	if go_up and _input_history_index == 0:
		input_history[0] = command_line.text
	
	if go_up:
		_input_history_index += 1
	else:
		_input_history_index -= 1
	
	_input_history_index = clamp(
		_input_history_index,
		0, input_history.size() - 1
	)
	
	return input_history[_input_history_index]


# Make the container scroll all the way down
# to keep the command input visible
func update_scroll() -> void:
	#TODO find a more simple and clean way
	
	# Wait a process_frame to update the container correctly
	# if not, the scroll is going to jump to a position before
	# the new label added has changed the container size
	for x in range(3):
		#ALERT "hacky" way, awaiting just one frame can
		# make the problem cited above hapens anyway 
		await get_tree().process_frame
	scroll_container.set_deferred("scroll_vertical", scroll_container.get_v_scroll_bar().max_value)


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
func _on_command_line_text_submitted(new_text: String) -> void:
	command_line.clear()
	
	push_input_to_history(new_text)
	push_line_to_output("~ > " + new_text)
	
	# if user inputs a empty string
	if new_text.replace(" ", "") == "":
		return
	
	var parsed_input: ParserOutput = parse_input(new_text)
	if commands.has(parsed_input.command_call_name):
		var cmd: TerminalCommand = commands.get(parsed_input.command_call_name)
		cmd.execute(self, parsed_input.command_args)
	else:
		push_line_to_output("%s not found" % [parsed_input.command_call_name])


func _on_command_line_gui_input(event: InputEvent) -> void:
	# Increments index and get input at that time
	if event.is_action_pressed("ui_text_caret_up"):
		command_line.text = get_input_in_history(true)
		command_line.set_deferred("caret_column", command_line.text.length())
	
	# Decrements index and get input at that time
	elif event.is_action_pressed("ui_text_caret_down"):
		command_line.text = get_input_in_history(false)
		command_line.set_deferred("caret_column", command_line.text.length())


class ParserOutput:
	var command_call_name: String
	var command_args: Array[String]
	
	func _init(call_name: String, args: Array[String]) -> void:
		command_call_name = call_name
		command_args = args
