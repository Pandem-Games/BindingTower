extends PathFollow2D

# Constants
const speed = 100.0

# Signals
signal enemy_spawned
signal enemy_killed

# State
enum eEnemy {MOVE, FINISH}
var state: int = eEnemy.MOVE

# Variables
export(int) var max_health
export(PackedScene) var damage_number_resource
onready var sprite := $Area/Collision/Sprite
var health: int

# Functions
func move(delta: float):
	sprite.visible = true
	offset += speed * delta
	if unit_offset >= 1.0:
		finish()

# Calculates a hit from a bullet
func hit(bullet: Node2D):
	# Subtracting health from bullet
	health -= bullet.damage
	bullet.queue_free()
	
	# Spawning damage number
	var damage_number: Node2D = damage_number_resource.instance()
	damage_number.init(bullet.damage, self.position)
	Helpers.get_main_node().add_child(damage_number)
	
	# Calculating death
	if health <= 0:
		finish()

# Called when the scene is finished
func finish():
	sprite.visible = false
	emit_signal(Constants.ENEMY_KILLED)
	state = eEnemy.FINISH

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.visible = false
	health = max_health
	add_to_group(Constants.ENEMIES)
	state = eEnemy.MOVE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	match state:
		eEnemy.MOVE:
			move(delta)
