extends Sprite

class_name Item

# State
enum eItem {DROPPED, ACTIVE, FINISHED}
var state: int = eItem.DROPPED

# Variables
onready var control: Control = $Control
onready var audio: AudioStreamPlayer = $PickupSound
var item_count: int = 1

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

func _item_on_hit(_bullet: Node2D, _target: Node2D) -> void:
	pass

func _on_Control_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		match state:
			eItem.DROPPED:
				visible = false
				audio.play()
				yield(audio, "finished")
				Helpers.call_error_function(Helpers, "add_item", [self])
				state = eItem.ACTIVE
				Helpers.safe_disconnect(control, "gui_input", self, "_on_Control_gui_input")
