extends Item

class_name ItemBulletClone
func get_class() -> String: 
	return "ItemBulletClone"
	
# Constants
const BULLET_COUNT_PROPERTY = "bullet_count"

# Variables
var bullet_count = 0

# Functions
func _item_on_hit(_bullet: Node2D, _target: Node2D) -> void:
	# We define a meta property on bullets to figure out how many times the 
	# bullet has cloned
	if _bullet.has_meta(BULLET_COUNT_PROPERTY):
		bullet_count = _bullet.get_meta(BULLET_COUNT_PROPERTY)
	else:
		bullet_count = item_count
	
	if bullet_count != 0:
		
		# After hitting the current enemy we want to find the closest enemy that
		# isn't the target
		var enemies = get_tree().get_nodes_in_group(Constants.ENEMIES)
		enemies.remove(enemies.find(_target))
		var closest = Helpers.get_closest_object(_target, enemies)
		if closest:
			# Create a bullet clone and change it's metadata accordingly
			var new_bullet = Constants.BULLET_RESOURCE.instance()
			new_bullet.init(weakref(closest))
			new_bullet.set_meta(BULLET_COUNT_PROPERTY, bullet_count - 1)
			
			# Adding the bullet to the scene
			Helpers.get_main_node().add_child(new_bullet)
			new_bullet.global_position = _target.global_position
