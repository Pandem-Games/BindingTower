extends Node2D

# Get's the main node for the game
func get_main_node() -> Node2D:
	return (get_tree().get_root().get_node("Main") as Node2D)

# Calls a function that returns an error and prints a debug message for that error
func call_error_function(object: Object, function_name: String, argument_array: Array) -> void:
	var error: int = object.callv(function_name, argument_array)
	if error != 0:
		print("Error calling function ", function_name, " on ", object, " {", error, "}")

# TODO add comment
func safe_disconnect(object: Object, signal_name: String, target: Object, method: String):
	if object.is_connected(signal_name, target, method):
		object.disconnect(signal_name, target, method)
	else:
		print("Unable to disconnect ", signal_name, " signal to method ", method)
		
func get_closest_object(target: Node2D, objects: Array) -> Node2D:
	
	if objects:
		var minimum: float = target.position.distance_to(objects[0].position)
		var closest_object: Node2D = objects[0]
		for i in range(1, objects.size()):
			var temp: float = target.position.distance_to(objects[i].position)
			if temp < minimum:
				minimum = temp
				closest_object = objects[i]
		return closest_object
	else:
		return null
