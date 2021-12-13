extends Node2D

# Constants
const INITIAL_ENEMY_COUNT := 10
const ENEMY_INCREASE_RATE := 1.2
const INCREASE_RATE_VARIANCE := 0.1
const POINT_VARIATION := 10.0
const SPAWN_TIME := 20.0

# State
enum eSpawner {SPAWNING, SPAWN, WAIT, POST_ROUND, FINISH}
var state: int = eSpawner.SPAWN

# Variables
#export(PackedScene) var enemy_resource
var enemies := []
var elapsedTime: float
var curve: Curve2D
var wave: int = 0
var num_enemies: int = INITIAL_ENEMY_COUNT
onready var path: Node2D = $MainPath
onready var post_round_timer : Timer = $PostRound

# Functions
func _ready() -> void:
	path.curve = curve
	elapsedTime = 0.0

# Spawns enemies who's timers have elapsed
func spawn() -> void:
	state = eSpawner.SPAWNING
	enemies = []
	num_enemies = int(float(num_enemies) * (ENEMY_INCREASE_RATE + RN.G.randf_range(-INCREASE_RATE_VARIANCE, INCREASE_RATE_VARIANCE)))
	for _i in range(num_enemies):
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
		Helpers.call_error_function(enemy_path.get_node("Path/Enemy"), "connect", [Constants.ENEMY_KILLED, self, "_enemy_finished"])
		enemy_path.init(curve_dup)
		enemies.append(enemy_path)

		yield(get_tree().create_timer(RN.G.randf() * (SPAWN_TIME / num_enemies)), "timeout")
		self.add_child(enemy_path)
		
	state = eSpawner.WAIT
	
func wait() -> void:
	# Check to see if any enemies are left
	if enemies.empty():
		# Start post round timer
		post_round()
		
func post_round() -> void:
	state = eSpawner.POST_ROUND
	post_round_timer.start()
	
func finish() -> void:
	queue_free()

# Initializes the class
func init(c: Curve2D) -> void:
	self.curve = c
	
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	match state:
		eSpawner.WAIT:
			wait()
		eSpawner.SPAWN:
			spawn()

func _enemy_finished(enemy: Node2D) -> void:
	# Remove from list of enemies
	if enemies.has(enemy):
		enemies.erase(enemy)
	
	# delete enemy
	enemy.queue_free()
