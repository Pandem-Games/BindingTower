extends Node2D

# Constants
const NUM_ENEMIES = 100
const POINT_VARIATION = 10.0
const MAX_DELAY: float = 20.0

# State
enum eSpawner {SPAWN, WAIT, FINISH}
var state: int = eSpawner.SPAWN

# Variables
#export(PackedScene) var enemy_resource
var enemies := []
var elapsedTime: float
var curve: Curve2D
onready var path: Node2D = $MainPath

# Functions
func _ready() -> void:
	path.curve = curve
	elapsedTime = 0.0
	state = eSpawner.SPAWN

# Spawns enemies who's timers have elapsed
func spawn() -> void:
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
		var enemy_path: Node2D = Constants.ENEMY_PATH_RESOURCE.instance()
		enemy_path.init(curve_dup)
		enemies.append(enemy_path)

		var timer := get_tree().create_timer(RN.G.randf() * MAX_DELAY)
		Helpers.call_error_function(timer, "connect", ["timeout", self, "_on_timeout"])
		
	state = eSpawner.WAIT
		
func _on_timeout() -> void:
	self.add_child(enemies.pop_back())
	
func wait() -> void:
	pass
	
func finish() -> void:
	queue_free()

# Initializes the class
func init(c: Curve2D) -> void:
	self.curve = c
	
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	match state:
		eSpawner.SPAWN:
			spawn()
		eSpawner.WAIT:
			wait()
