extends Item

class_name ItemSpeed
func get_class() -> String: 
	return "ItemSpeed"
	
# Functions
func _item_initial(tower: Node2D) -> void:
	tower.cooldown_time *= 0.2
