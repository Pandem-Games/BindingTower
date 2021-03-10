extends Node2D

# Get's the main node for the game
func get_main_node() -> Node2D:
	return (get_tree().get_root().get_node_or_null("Main") as Node2D)

# Calls a function that returns an error and prints a debug message for that error
func call_error_function(object: Object, function_name: String, argument_array: Array) -> void:
	var error: int = object.callv(function_name, argument_array)
	if error != 0:
		print("Error calling function ", function_name, " on ", object, " {", error, "}")

# Disconnects a signal from an object only if the signal exists
func safe_disconnect(object: Object, signal_name: String, target: Object, method: String) -> void:
	if object.is_connected(signal_name, target, method):
		object.disconnect(signal_name, target, method)
	else:
		print("Unable to disconnect ", signal_name, " signal to method ", method)
		
# Given an array of objects, it will find the closest object to the given node and return it
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

func get_items() -> Array:
	var main_node = get_main_node()
	if main_node:
		var item_node = main_node.get_node_or_null("Items")
		if item_node:	
			return item_node.get_children()
	
	return []
	
func add_item(item: Node2D) -> int:
	var main_node = get_main_node()
	if main_node:
		if item.get_parent():
			item.get_parent().remove_child(item)

		var item_node = main_node.get_node_or_null("Items")
		if item_node:
			item_node.add_child(item)
		else:
			var new_node = Node2D.new()
			new_node.name = "Items"
			new_node.add_child(item)
			main_node.add_child(new_node)
		return OK
	
	return ERR_UNAVAILABLE
