extends Sprite

class_name Item

# State
enum eItem {DROPPED, ACTIVE, FINISHED}
var state: int = eItem.DROPPED

# Variables
export(float) var float_amount := 1.0
export(float) var initial_float_height := 0.5
onready var control: Control = $Control
onready var audio: AudioStreamPlayer = $PickupSound
onready var item_shadow: AnimatedSprite = $ItemShadow
var item_count: int = 1
var current_time: float = 0.0
var animation_length: float = 0.0

# Functions
func _ready() -> void:
	visible = true
	state = eItem.DROPPED
	animation_length = Helpers.get_animation_length(item_shadow.frames, "default")
	current_time = initial_float_height / animation_length
	
func _process(delta: float) -> void:
	match state:
		eItem.DROPPED:
			var height: float = sin(current_time * ((2 * PI) / animation_length))
			offset.y = height * float_amount
			current_time += delta
	
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
