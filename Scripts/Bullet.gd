extends Area2D

class_name Bullet

# Constants

# Signals

# State
enum eBullet { MOVE, FINISH }
var state = eBullet.MOVE

# Variables
var target: WeakRef
export(float) var speed
export(int) var damage

# Functions
func move(delta):
	if target.get_ref():
		var direction = global_position.direction_to(target.get_ref().global_position)
		translate(direction * speed * delta)
	else:
		queue_free()
	
func finish():
	$Area/Sprite.visible = false
	state = eBullet.FINISH
	
func init(target):
	self.target = target
	state = eBullet.MOVE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		eBullet.MOVE:
			move(delta)

func _on_Bullet_area_entered(area):
	if area.get_parent() is Enemy:
		area.get_parent().call_deferred("hit", self)
		finish()
