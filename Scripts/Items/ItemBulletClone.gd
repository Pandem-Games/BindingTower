extends Item

func _item_on_hit(_bullet: Node2D, _target: Node2D) -> void:
	print("Bullet hit!")
	var enemies = get_tree().get_nodes_in_group(Constants.ENEMIES)
	var closest = Helpers.get_closest_object(self, enemies)
	if closest:
		var new_bullet = Constants.BULLET_RESOURCE.instance()
		new_bullet.init(weakref(closest))
		Helpers.get_main_node().add_child(new_bullet)
		new_bullet.global_position = _target.global_position
