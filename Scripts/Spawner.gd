extends Node2D

# Constants
const NUM_ENEMIES = 5
const POINT_VARIATION = 10.0
const MAX_DELAY = 5.0

# State
enum eSpawner {SPAWN, WAIT, FINISH}
var state: int = eSpawner.SPAWN

# Variables
export(PackedScene) var enemy_resource
var enemies := []
var elapsedTime: float
var curve: Curve2D
onready var path: Node2D = $MainPath

# Functions
func _ready():
	path.curve = curve
	

	elapsedTime = 0.0
	state = eSpawner.SPAWN

# Spawns enemies who's timers have elapsed
func spawn():
	for _i in range(NUM_ENEMIES):
		# TODO: Move to EnemyPath.gd
		# Duplicate curve so that the curve can be given to each enemy
		var curve_dup: Curve2D = path.curve.duplicate()
		
		# Loop through each point and randomize it's position slightly
		for j in curve_dup.get_point_count():
			var p := curve_dup.get_point_position(j)
			var x: float = p.x + RN.G.randf_range(-POINT_VARIATION, POINT_VARIATION)
			var y: float = p.y + RN.G.randf_range(-POINT_VARIATION, POINT_VARIATION)
			var position := Vector2(x, y)
			curve_dup.set_point_position(j, position)
		
		# Create the enemy
		var enemy_path: Node2D = enemy_resource.instance()
		enemy_path.init(curve_dup)
		enemies.append(enemy_path)
		var enemy: Node2D = enemy_path.get_node("Path/Enemy")
		Helpers.call_error_function(enemy, "connect", [Constants.ENEMY_KILLED, self, "_on_Enemy_killed"])
		
		var timer := get_tree().create_timer((RN.G.randf() * MAX_DELAY) as float)
		timer.connect("timeout", self, "_on_timeout")
		
	state = eSpawner.WAIT
		
func _on_timeout():
	self.add_child(enemies.pop_back())
	
func wait():
	pass
	
func finish():
	queue_free()

# Initializes the class
func init(c: Curve2D):
	self.curve = c
	
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float):
	match state:
		eSpawner.SPAWN:
			spawn()
		eSpawner.WAIT:
			wait()

# Signal function ran when an enemy reaches the end of the path
func _on_Enemy_killed():
	print("Enemy finished path")
