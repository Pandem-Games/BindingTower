extends Node2D

# Variables
export(PackedScene) var spawner_resource
onready var path := $Background/Path

# Functions
func _ready():
	var spawner: Node2D = spawner_resource.instance()
	spawner.init(path.curve.duplicate())
	add_child(spawner)
