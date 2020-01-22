extends Node2D

# Constants

# Signals

# State
enum eMap {WAIT, FINISH}
var state = eMap.WAIT

# Variables
export(PackedScene) var tower_resource
export(PackedScene) var spawner_resource
onready var path = $Background/Path

# Functions
func _ready():
	var spawner = spawner_resource.instance()
	spawner.init(path.curve.duplicate())
	add_child(spawner)
	
	var tower = tower_resource.instance()
	add_child(tower)
	tower.position = Vector2(490, 146)
	
	spawner.connect(Constants.ENEMY_SPAWNED, tower, "_on_Enemy_spawned")

func wait():
	pass

func finish():
	pass

