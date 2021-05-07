extends Area2D

class_name Bullet

# Constants

# Signals

# State
enum eBullet { MOVE, FINISH }
var state: int = eBullet.MOVE

# Variables
var target: WeakRef
var items := []
export(float) var speed
export(int) var damage

# Functions

# Moves the bullet towards the target
func move(delta: float) -> void:
	# Tries to get target location and move towards it
	if target.get_ref():
		var direction: Vector2 = global_position.direction_to(target.get_ref().global_position)
		translate(direction * speed * delta)
	else:
		var enemies = Helpers.get_group(Constants.ENEMIES)
		if enemies:
			var enemy = Helpers.get_closest_object(self, enemies)
			if enemy:
				target = weakref(enemy)
				move(delta)
				return
		queue_free()

# Called when the bullet is finished
func finish() -> void:
	$Area/Sprite.visible = false
	state = eBullet.FINISH
	queue_free()

# Initializer for the class
func init(t: WeakRef) -> void:
	self.target = t
	self.items = Helpers.get_items()
	state = eBullet.MOVE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		eBullet.MOVE:
			move(delta)

# Signal called when the bullet enters an enemy
func _on_Bullet_area_entered(area: Area2D) -> void:
	var target_value: Node2D = target.get_ref()
	if target_value:
		if area.get_parent() == target_value:
			target_value.call_deferred("hit", self)
			for item in items:
				item._item_on_hit(self, target_value)
			finish()
	else:
		finish()
