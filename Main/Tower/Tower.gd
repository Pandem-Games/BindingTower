extends Node2D

class_name Tower

# Signals
signal tower_placement_confirmed

# State
enum eTower {SELECTING, RESTRICTED, COOLDOWN, WAIT, FINISH}
var state: int = eTower.WAIT

# Variables
export(float) var radius
export(float) var cooldown_time
export(int) var circle_vertices
export(Color) var restricted_color
export(int) var cost := 20
onready var range_shape := $Range/Shape
onready var range_ui := $RangeUI
onready var collision_shape := $Collision/Shape
onready var main_node: Node2D = Helpers.get_main_node()
#onready var tower_area := $Area
var enemies := []
var restricted_areas := []
var restricted_bodies := []
var elapsed_time := 0.0
var items := []

# Functions

# Fires a bullet at the given enemy
func fire_at(enemy: WeakRef) -> void:
	# Adding the bullet to the scene
	var bullet: Node2D = Constants.BULLET_RESOURCE.instance()
	bullet.init(enemy)
	Helpers.get_main_node().add_child(bullet)
	bullet.global_position = global_position

	# Resetting the cooldown timer
	elapsed_time = 0.0
	state = eTower.COOLDOWN
	

# Waits for an enemy to get in range to fire at
func wait() -> void:
	for enemy in enemies:
		# Firing at enemy if they exist
		if enemy.get_ref():
			fire_at(enemy)
			break
		# If they don't exist then they need to be removed
		else:
			enemies.remove(enemies.find(enemy))

# Calculates the cooldown for firing a bullet
func cooldown(delta: float) -> void:
	# Incrementing the cooldown timer and changing state if timer finishes
	elapsed_time += delta
	if elapsed_time >= cooldown_time:
		state = eTower.WAIT
		wait()

# Changes the tower position to the mouse position
func follow_mouse() -> void:
	global_position = get_global_mouse_position()
	if state == eTower.RESTRICTED and restricted_areas.empty() and restricted_bodies.empty() and main_node.gears >= cost:
		selected()

# Restricts the tower from being placed
func restricted() -> void:
	modulate = restricted_color
	state = eTower.RESTRICTED

# Allows the user to place the tower if they click
func selected() -> void:
	modulate = Color.white
	state = eTower.SELECTING

# Used when the tower is no longer needed
func finish() -> void:
	state = eTower.FINISH
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Changing the firing radius
	range_shape.get_shape().radius = radius
	
	# Creating a circle representing the towers range to display to the user
	var circle: PoolVector2Array = range_ui.polygon
	for i in range(circle_vertices):
		circle.push_back(polar2cartesian(radius, i * (TAU / circle_vertices)))
	range_ui.polygon = circle
	
	collision_shape.disabled = true
	
	# Setting the tower to selected
	global_position = get_global_mouse_position()
	if main_node.gears >= cost:
		selected()
	else:
		restricted()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		# Tower is waiting for an enemy to appear in range
		eTower.WAIT:
			wait()
		# Tower is waiting for it's cooldown to finish to fire again
		eTower.COOLDOWN:
			cooldown(delta)
		# Tower is waiting for user to placement position
		eTower.SELECTING, eTower.RESTRICTED:
			follow_mouse()

# Signal function called when an enemy body enters the towers area
func _on_Range_area_entered(area: Area2D) -> void:
	# Appending a weak reference to the enemy so that if it gets killed and
	# removed from the scene, accessing the reference won't crash godot
	enemies.append(weakref(area.get_parent()))

# Signal function called when an enemy body leaves the towers area
func _on_Range_area_exited(area: Area2D) -> void:
	for i in range(enemies.size()):
		# Removing the enemy reference when it exits the towers range
		var enemy: Node2D = enemies[i].get_ref()
		if enemy == area.get_parent():
			enemies.remove(i)
			break

# Signal function called when the tower is overlapping another tower or the path
func _on_Area_area_entered(area: Area2D) -> void:
	restricted_areas.append(weakref(area))
	if state == eTower.SELECTING:
		restricted()

# Signal function called when the tower is overlapping another restricted body	
func _on_Area_body_entered(body: KinematicBody2D) -> void:
	restricted_bodies.append(weakref(body))
	if state == eTower.SELECTING:
		restricted()

# Signal function called when tower leaves restricted placement area
func _on_Area_area_exited(area: Area2D) -> void:
	for i in range(restricted_areas.size()):
		# Removing the collision reference when it exits the towers area
		var restricted_area: Area2D = restricted_areas[i].get_ref()
		if restricted_area == area:
			restricted_areas.remove(i)
			break
	# If the current area is not overlapping any areas then unrestrict the tower
	if state == eTower.RESTRICTED and restricted_areas.empty() and restricted_bodies.empty() and main_node.gears >= cost:
		selected()

# Signal function called when the tower leaves a restricted placement area
func _on_Area_body_exited(body: KinematicBody2D) -> void:
	for i in range(restricted_bodies.size()):
		# Removing the collision reference when it exits the towers area
		var restricted_body: KinematicBody2D = restricted_bodies[i].get_ref()
		if restricted_body == body:
			restricted_bodies.remove(i)
			break
	# If the current area is not overlapping any areas then unrestrict the tower
	if state == eTower.RESTRICTED and restricted_bodies.empty() and restricted_areas.empty() and main_node.gears >= cost:
		selected()

# Signal function called when the tower placement gets cancelled
func _on_Tower_placement_cancelled() -> void:
	# Deletes the tower if it was being placed
	if state == eTower.SELECTING or state == eTower.RESTRICTED:
		finish()

# Signal function called when the user clicks on the tower area
func _on_TowerControl_gui_input(event: InputEvent) -> void:
	if state == eTower.SELECTING and event.is_action_pressed("ui_select"):
		# Disable the towers range ui then change the tower to waiting
		range_ui.visible = false
		collision_shape.disabled = false
		
		# Adding items to the tower
		self.items = Helpers.get_items()
		for i in items:
			i._item_initial(self)
		
		state = eTower.WAIT
		emit_signal(Constants.TOWER_PLACEMENT_CONFIRMED, cost)
