extends Sprite

func _item_on_hit(_bullet: Node2D) -> void:
	var enemies = get_tree().get_nodes_in_group(Constants.ENEMIES)
	var closest = Helpers.get_closest_object(self, enemies)
	if closest:
		var bullet = Constants.BULLET_RESOURCE.instance()
		bullet.init(weakref(closest))
		Helpers.get_main_node().add_child(bullet)
