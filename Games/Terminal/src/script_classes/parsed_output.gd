class_name ParserOutput
## A helper Class for InputParser.
##
## Is intended to be used only in the parser logic.[br]
## Example:
## [codeblock]
## var output = ParserOutput.new("echo", ["hello", "world"])
## print(output.command_call_name)# prints "echo"
## print(ouput.command_args)# prints ["hello", "world"]
## [/codeblock]

## The name used for calling the command.
var command_call_name: String
## The arguments used in the command.
var command_args: Array[String]


func _init(call_name: String, args: Array[String]) -> void:
	command_call_name = call_name
	command_args = args
