extends Node2D

# Constants

# Signals

# State
enum eTower {SELECTING, RESTRICTED, COOLDOWN, WAIT, FINISH}
var state = eTower.WAIT
var enemies = []
var removed_enemies = []

# Variables
export(float) var distance
export(float) var cooldown_time
var elapsed_time = 0.0
export(PackedScene) var bullet_resource
onready var tower_range = $Range
onready var range_shape = $Range/Shape
onready var restricted_sprite = $Restricted

# Functions

# Fires a bullet at the given enemy
func fire_at(enemy):
	# Adding the bullet to the scene
	var bullet = bullet_resource.instance()
	bullet.init(enemy)
	add_child(bullet)
	
	# Resetting the cooldown timer
	elapsed_time = 0.0
	state = eTower.COOLDOWN
	

# Waits for an enemy to get in range to fire at
func wait():
	for enemy in enemies:
		# Firing at enemy if they exist
		if enemy.get_ref():
			fire_at(enemy)
			break
		# If they don't exist then they need to be removed
		else:
			enemies.remove(enemies.find(enemy))

# Calculates the cooldown for firing a bullet
func cooldown(delta):
	# Incrementing the cooldown timer and changing state if timer finishes
	elapsed_time += delta
	if elapsed_time >= cooldown_time:
		state = eTower.WAIT
		wait()
		
func follow_mouse():
	global_position = get_global_mouse_position()
	
func restricted():
	restricted_sprite.visible = true
	state = eTower.RESTRICTED
	
func selected():
	restricted_sprite.visible = false
	state = eTower.SELECTING

func finish():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	# Changing the firing radius
	range_shape.get_shape().radius = distance
	print(tower_range.visible)
	restricted_sprite.visible = true
	
	state = eTower.SELECTING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		eTower.WAIT:
			wait()
		eTower.COOLDOWN:
			cooldown(delta)
		eTower.SELECTING, eTower.RESTRICTED:
			follow_mouse()
			
func _unhandled_input(event):
	pass

# Signal function called when an enemy body enters the towers area
func _on_Range_area_entered(area):
	# Appending a weak reference to the enemy so that if it gets killed and
	# removed from the scene, accessing the reference won't crash godot
	enemies.append(weakref(area.get_parent()))

# Signal function called when an enemy body leaves the towers area
func _on_Range_area_exited(area):
	for i in range(0, enemies.size()):
		# Removing the enemy reference when it exits the towers range
		var enemy = enemies[i].get_ref()
		if enemy == area.get_parent():
			enemies.remove(i)
			break


func _on_Area_area_entered(area):
	if state == eTower.SELECTING:
		restricted()


func _on_Area_area_exited(area):
	if state == eTower.RESTRICTED:
		selected()
