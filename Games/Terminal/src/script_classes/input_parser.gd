class_name InputParser
## Utility class used for sanitizing and parsing Strings.
##
##Example:
##[codeblock]
##var parser := InputParser.new()
##var output: ParserOuput = parser.parse("echo hello world"))
##
##print(output.command_call_name)# prints "echo"
##print(output.command_args)# prints ["hello", "world"]
##[/codeblock]


## Sanitize and parse the given String.[br]
##
## Trailing spaces will be removed and quotations merge arguments into one.
##[codeblock]
##echo hello world -> "echo", ["hello", "world"]
##echo "hello world" -> "echo", ["hello world"]
##[/codeblock]
func parse(input: String) -> ParserOutput:
	# Return early if empty String
	if input == "" or input.count(" ") == input.length():
		return ParserOutput.new("", [])
	
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
