extends Item

# Functions
func _item_initial(tower: Node2D) -> void:
	tower.cooldown_time *= 0.5
