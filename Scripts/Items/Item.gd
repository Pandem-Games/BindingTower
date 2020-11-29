extends Sprite

class_name Item

# State
enum eItem {DROPPED, ACTIVE, FINISHED}
var state: int = eItem.DROPPED

# Variables
onready var control = $Control

# Functions
func _ready() -> void:
	visible = true
	state = eItem.DROPPED
	
func finish() -> void:
	state = eItem.FINISHED
	queue_free()
	
# Virtual functions to override
func _item_initial(_tower: Node2D) -> void:
	pass

func _item_on_fire(_bullet: Node2D) -> void:
	pass

func _item_on_bullet_processed(_bullet: Node2D) -> void:
	pass

func _item_on_hit(_bullet: Node2D) -> void:
	pass

func _on_Control_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		match state:
			eItem.DROPPED:
				var towers := get_tree().get_nodes_in_group(Constants.TOWERS)
				if towers:
					visible = false
					state = eItem.ACTIVE
					Helpers.safe_disconnect(control, "gui_input", self, "_on_Control_gui_input")
					for tower in towers:
						tower.add_item(self)
