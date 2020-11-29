extends Node

# Get's the main node for the game
func get_main_node() -> Node:
	return get_tree().get_root().get_node("Main")

# Calls a function that returns an error and prints a debug message for that error
func call_error_function(object: Object, function_name: String, argument_array: Array) -> void:
	var error: int = object.callv(function_name, argument_array)
	if error != 0:
		print("Error calling function ", function_name, " on ", object, " {", error, "}")


func safe_disconnect(object: Object, signal_name: String, target: Object, method: String):
	if object.is_connected(signal_name, target, method):
		object.disconnect(signal_name, target, method)
	else:
		print("Unable to disconnect ", signal_name, " signal to method ", method)
