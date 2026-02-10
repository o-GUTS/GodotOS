class_name InputHistoryManager
## Utility class to handle input history.
##
## Uses a custom queue to store the data.
## But is [b]not[/b] intended to be accessed directly, for this use [method push_to_history] or [method get_next].[br]
## Go to [member _input_history] for more information.
##@experimental: This class is work in progress.


##@experimental
enum DIR {
	UP, DOWN
}

## The maximum of inputs that will be saved.
var max_history_size: int = 10

## A custom queue to store the user input history.[br]
## It follows 3 rules:[br]
##- new input is appended to the front.[br]
##- overflow input is removed from the back.[br]
##- the first element is reserved to [param command_line.text] when the user starts to navigate history
var _input_history: Array[String] = [""]

## Used and modified internally to get the data on [param _input_history].
var _input_history_index: int = 0

##@experimental
var cmd_line: LineEdit = null


func _init(command_line: LineEdit, max_size: int = 10) -> void:
	cmd_line = command_line
	max_history_size = max_size


## Append the given input to the front, don't interfering with the reserved first element.[br]
## If [member _input_history] size exceeds [member max_history_size], removes the last element.
func push_to_history(input: String) -> void:
	# Index 1 to not change the reserved first place
	_input_history.insert(1, input)
	
	if _input_history.size() > max_history_size:
		_input_history.pop_back()
	
	# Sets to zero, so the next history navigation
	# can start in the right place 
	_input_history_index = 0


# Returns the value in input_history[_input_history_index +- 1]
# and updates the history index
##@experimental
func get_next(dir: DIR) -> String:
	# If user is starting the history navigation then sets the
	# first element on the array to the current text in the command_line
	if dir == DIR.UP and _input_history_index == 0:
		_input_history[0] = cmd_line.text
	
	if dir == DIR.UP:
		_input_history_index += 1
	elif dir == DIR.DOWN:
		_input_history_index -= 1
	
	_input_history_index = clamp(
		_input_history_index,
		0, _input_history.size() - 1
	)
	
	return _input_history[_input_history_index]
