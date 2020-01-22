extends Node2D

# Constants
const NUM_ENEMIES = 5
const POINT_VARIATION = 10.0
const MAX_DELAY = 5.0

# Signals
signal enemy_spawned

# State
enum eSpawner {SPAWN, WAIT, FINISH}
var state = eSpawner.SPAWN

# Variables
export(PackedScene) var enemy_resource
var enemies := []
var delays := []
var elapsedTime: float
var curve: Curve2D

# Functions
func _ready():
	$MainPath.curve = curve
	for i in range(NUM_ENEMIES):
		var curve = $MainPath.curve.duplicate()

		for j in curve.get_point_count():
			var p = curve.get_point_position(j)
			var x = p.x + RN.G.randf_range(-POINT_VARIATION, POINT_VARIATION)
			var y = p.y + RN.G.randf_range(-POINT_VARIATION, POINT_VARIATION)
			var position = Vector2(x, y)
			curve.set_point_position(j, position)
		
		var e = enemy_resource.instance()
		e.init(curve)
		enemies.append(e)
		var enemy = e.get_node("Path/Follow")
		enemy.connect(Constants.ENEMY_FINISHED, self, "_on_Enemy_finished")
		delays.append((RN.G.randf() * MAX_DELAY) as float)

	elapsedTime = 0.0
	state = eSpawner.SPAWN

func spawn(delta):
	elapsedTime += delta
	for i in range(delays.size()):
		if (delays[i] as float) != -1.0 && elapsedTime >= (delays[i] as float):
			self.add_child(enemies[i])
			delays[i] = -1
			emit_signal(Constants.ENEMY_SPAWNED, enemies[i].get_node("Path/Follow"))

	if elapsedTime >= delays.max():
		state = eSpawner.WAIT
	
func wait():
	pass
	
func finish():
	pass

func init(c):
	self.curve = c
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		eSpawner.SPAWN:
			spawn(delta)
		eSpawner.WAIT:
			wait()

func _on_Enemy_finished():
	print("Enemy finished path")
