extends Node2D

# Signals
signal tower_placement_confirmed

# State
enum eTower {SELECTING, RESTRICTED, COOLDOWN, WAIT, FINISH}
var state = eTower.WAIT
var enemies: Array = []
var collision_areas: Array = []
var elapsed_time: float = 0.0

# Variables
export(float) var radius
export(float) var cooldown_time
export(int) var circle_definition
export(PackedScene) var bullet_resource
export(Color) var restricted_color
onready var tower_range: Area2D = $Range
onready var range_shape: CollisionShape2D = $Range/Shape
onready var range_ui: Polygon2D = $RangeUI

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
	modulate = restricted_color
	state = eTower.RESTRICTED
	
func selected():
	modulate = Color.white
	state = eTower.SELECTING

func finish():
	state = eTower.FINISH
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Changing the firing radius
	range_shape.get_shape().radius = radius
	print(tower_range.visible)
	
	var vertex_pool: PoolVector2Array = range_ui.polygon
	for i in range(0, circle_definition):
		vertex_pool.push_back(polar2cartesian(radius, i * (TAU / circle_definition)))
	
	range_ui.polygon = vertex_pool
	global_position = get_global_mouse_position()
	selected()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		eTower.WAIT:
			wait()
		eTower.COOLDOWN:
			cooldown(delta)
		eTower.SELECTING, eTower.RESTRICTED:
			follow_mouse()
			
#func _unhandled_input(event):
#	if state == eTower.SELECTING and event.is_action_pressed("ui_select"):
#		range_ui.visible = false
#		state = eTower.WAIT
#		emit_signal(Constants.TOWER_PLACEMENT_CONFIRMED)
#		#accept_event()

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
	collision_areas.append(weakref(area))
	if state == eTower.SELECTING:
		restricted()


func _on_Area_area_exited(area):
	for i in range(0, collision_areas.size()):
		# Removing the enemy reference when it exits the towers range
		var collision_area = collision_areas[i].get_ref()
		if collision_area == area:
			collision_areas.remove(i)
			break
			
	if state == eTower.RESTRICTED and collision_areas.empty():
		selected()
		

func _on_Tower_placement_cancelled():
	if state == eTower.SELECTING or state == eTower.RESTRICTED:
		finish()


func _on_TowerControl_gui_input(event):
	if state == eTower.SELECTING and event.is_action_pressed("ui_select"):
		range_ui.visible = false
		state = eTower.WAIT
		emit_signal(Constants.TOWER_PLACEMENT_CONFIRMED)
		#accept_event()
