extends Node2D

# Variables
onready var path := $Background/Path
onready var lives_label := $UI/MainUIMargin/MainUI/Life/Bar/Margin/Items/Amount
var lives := 10

# Functions
func _ready() -> void:
	lives_label.text = str(lives)
	var spawner: Node2D = Constants.SPAWNER_RESOURCE.instance()
	spawner.init(path.curve.duplicate())
	add_child(spawner)

# When the enemy freakin wrecks your shit
func _enemy_finished(_enemy: Node2D) -> void:
	lives -= 1
	lives_label.text = str(lives)
	if lives <= 0:
		# Go to title screen
		Helpers.call_error_function(get_tree(), "change_scene", [Constants.menu_scene])
