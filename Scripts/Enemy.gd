extends PathFollow2D

class_name Enemy

# Constants
const speed = 100.0

# Signals 
signal enemy_finished
signal enemy_killed

# State
enum eEnemy {MOVE, FINISH}
var state = eEnemy.MOVE

# Variables
export(int) var max_health
export(PackedScene) var damage_number_resource
var health

# Functions
func move(delta):
	offset += speed * delta
	if unit_offset >= 1.0:
		finish()

func hit(bullet):
	health -= bullet.damage
	bullet.queue_free()
	var damage_number = damage_number_resource.instance()
	damage_number.init(bullet.damage, self.global_position)
	get_tree().get_root().get_node("Main").add_child(damage_number)
	if health <= 0:
		dead()

func dead():
	$Area/Collision/Sprite.visible = false
	emit_signal(Constants.ENEMY_KILLED)
	state = eEnemy.FINISH

func finish():
	$Area/Collision/Sprite.visible = false
	emit_signal(Constants.ENEMY_FINISHED)
	state = eEnemy.FINISH

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	add_to_group(Constants.ENEMIES)
	state = eEnemy.MOVE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		eEnemy.MOVE:
			move(delta)