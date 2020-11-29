extends Item

# Functions
func _item_initial(tower: Node2D):
	tower.cooldown_time *= 0.5
