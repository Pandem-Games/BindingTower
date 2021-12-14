extends Node2D

# Variables
onready var path := $Background/Path
onready var lives_label := $UI/MainUIMargin/MainUI/Life/Bar/Margin/Items/Amount
onready var gears_label := $UI/MainUIMargin/MainUI/Coins/Bar/Margin/Items/Amount
var lives := 10
var gears := 20

# Functions
func _ready() -> void:
	update_lives(lives)
	update_gears(gears)
	var spawner: Node2D = Constants.SPAWNER_RESOURCE.instance()
	spawner.init(path.curve.duplicate())
	add_child(spawner)
	
func update_lives(l: int) -> void: 
	lives = l
	lives_label.text = str(lives)
	
func update_gears(g: int) -> void:
	gears = g
	gears_label.text = str(gears)

# When the enemy freakin wrecks your shit
func _enemy_finished(_enemy: Node2D) -> void:
	update_lives(lives - 1)
	if lives <= 0:
		# Go to title screen
		Helpers.call_error_function(get_tree(), "change_scene", [Constants.menu_scene])
		
func _enemy_killed(_enemy: Node2D) -> void:
	update_gears(gears + 1)
		
func _on_Tower_placement_confirmed(cost: int) -> void:
	update_gears(gears - cost)
