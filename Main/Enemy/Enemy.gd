extends PathFollow2D

# Signals
signal enemy_spawned
signal enemy_killed
signal enemy_finished

# State
enum eEnemy {MOVE, FINISH}
var state: int = eEnemy.MOVE

# Variables
export(int) var max_health = 100
export(int) var speed = 100
export(float) var drop_rate := 0.05
onready var sprite := $Area/Collision/Sprite
onready var main_node: Node2D = Helpers.get_main_node()
var health: int

# Functions
func move(delta: float) -> void:
	sprite.visible = true
	offset += speed * delta
	if unit_offset >= 1.00:
		finish_path()

# Calculates a hit from a bullet
func hit(bullet: Node2D) -> void:
	# Subtracting health from bullet
	health -= bullet.damage
	bullet.queue_free()
	
	# Spawning damage number
	var damage_number: Node2D = Constants.DAMAGE_NUMBER_RESOURCE.instance()
	damage_number.init(bullet.damage, self.position)
	Helpers.get_main_node().add_child(damage_number)
	
	# Calculating death
	if health <= 0:
		finish()

# Called when the scene is finished
func finish() -> void:
	state = eEnemy.FINISH
	sprite.visible = false
	if RN.G.randf() <= drop_rate:
		var item: Node2D = Constants.ITEM_RESOURCES.get(Constants.ITEM_RESOURCES.keys()[RN.G.randi_range(0, Constants.ITEM_RESOURCES.size() - 1)]).instance()
		main_node.add_child(item)
		item.global_position = global_position
	emit_signal(Constants.ENEMY_KILLED, self.get_parent().get_parent())

# Differentiating between dying and finishing the path
func finish_path() -> void:
	emit_signal(Constants.ENEMY_FINISHED, self.get_parent().get_parent())
	finish()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.visible = false
	health = max_health
	add_to_group(Constants.ENEMIES)
	state = eEnemy.MOVE
	loop = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		eEnemy.MOVE:
			move(delta)
