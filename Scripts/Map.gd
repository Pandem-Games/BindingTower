extends Node2D

# State
enum eMap {WAIT, FINISH}
var state: int = eMap.WAIT

# Variables
export(PackedScene) var tower_resource
export(PackedScene) var spawner_resource
onready var path := $Background/Path

# Functions
func _ready():
	var spawner: Node2D = spawner_resource.instance()
	spawner.init(path.curve.duplicate())
	add_child(spawner)

func wait():
	pass

func finish():
	pass
