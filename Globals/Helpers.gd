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
		var minimum: float = target.global_position.distance_to(objects[0].global_position)
		var closest_object: Node2D = objects[0]
		for i in range(1, objects.size()):
			var temp: float = target.global_position.distance_to(objects[i].global_position)
			if temp < minimum:
				minimum = temp
				closest_object = objects[i]
		return closest_object
	else:
		return null

# Gets all currently active items via the group
func get_items() -> Array:
	return get_tree().get_nodes_in_group(Constants.ITEMS)

# Adds an item to the players active items
func add_item(item: Node2D) -> int:
	var main_node = get_main_node()
	if main_node:
		if item.get_parent():
			item.get_parent().remove_child(item)
		
		# Adding item to active item group
		
		# Active items are stored under a node underneath the main node
		var item_node = main_node.get_node_or_null("Items")
		if item_node:
			# If the containing active node exists then we want to check if there's 
			# an existing item of the same type, in which case we add to it
			var items = item_node.get_children()
			for same_item in items:
				print(same_item.get_class(), item.get_class())
				if same_item.get_class() == item.get_class():
					(same_item as Item).item_count += 1
					return OK
			
			# Otherwise if there isn't then 
			print("Adding item to group!")
			item.add_to_group(Constants.ITEMS)
			item_node.add_child(item)
		else:
			# if the item node doesn't exist then we create it and add it to the main node
			var new_node = Node2D.new()
			new_node.name = "Items"
			print("Adding item to group!")
			item.add_to_group(Constants.ITEMS)
			
			new_node.add_child(item)
			main_node.add_child(new_node)
		return OK
	
	return ERR_UNAVAILABLE
