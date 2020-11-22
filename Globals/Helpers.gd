extends Node

# Get's the main node for the game
func get_main_node():
	return get_tree().get_root().get_node("Main")

# Calls a function that returns an error and prints a debug message for that error
func call_error_function(object: Object, function_name: String, argument_array: Array):
	var error: int = object.callv(function_name, argument_array)
	if error != 0:
		print("Error calling function ", function_name, " on ", object, " {", error, "}")
