extends Node2D

# Constants

# Signals

# State
enum eTower {COOLDOWN, WAIT, FINISH}
var state = eTower.WAIT
var enemies = []
var removed_enemies = []

# Variables
export(float) var distance
export(float) var cooldown
var elapsedTime = 0.0
export(PackedScene) var bullet_resource

# Functions
func fire_at(enemy):
	var bullet = bullet_resource.instance()
	bullet.init(enemy)
	add_child(bullet)
	elapsedTime = 0.0
	state = eTower.COOLDOWN
	

func wait():
	removed_enemies = []
	
	for enemy in enemies:
		if !enemy.get_ref():
			removed_enemies.append(enemy)
		else:
			if global_position.distance_to(enemy.get_ref().global_position) <= distance:
				fire_at(enemy)
				break
	
	for enemy in removed_enemies:
		enemies.remove(enemies.find(enemy))

func cooldown(delta):
	elapsedTime += delta
	if elapsedTime >= cooldown:
		state = eTower.WAIT
		wait()

func finish():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	state = eTower.WAIT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		eTower.WAIT:
			wait()
		eTower.COOLDOWN:
			cooldown(delta)

func _on_Enemy_spawned(enemy):
	enemies.append(weakref(enemy))
