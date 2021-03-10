extends Node2D

# Variables
onready var path := $Background/Path

# Functions
func _ready() -> void:
	var spawner: Node2D = Constants.SPAWNER_RESOURCE.instance()
	spawner.init(path.curve.duplicate())
	add_child(spawner)
