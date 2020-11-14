extends Node

# Get's the main node for the game
func get_main_node():
	return get_tree().get_root().get_node("Main")
