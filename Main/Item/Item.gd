extends Sprite

class_name Item

# State
enum eItem {DROPPED, GRABBABLE, ACTIVE, FINISHED}
var state: int = eItem.DROPPED

# Variables

# Used to handle float amplitude and starting values for the floating animation
export(float) var float_amount := 1.0
export(float) var initial_float_height := 0.5
var current_time: float = 0.0
var animation_length: float = 0.0

onready var interact_label: RichTextLabel = $Control/Label
onready var audio: AudioStreamPlayer = $PickupSound
onready var item_shadow: AnimatedSprite = $ItemShadow

# Keeps track of how many of this item has been collected
var item_count: int = 1

# Functions
func _ready() -> void:
	# When item is spawned it is dropped and visible
	visible = true
	dropped()
	animation_length = Helpers.get_animation_length(item_shadow.frames, "default")
	current_time = initial_float_height / animation_length
	item_shadow.playing = true
	
func _process(delta: float) -> void:
	match state:
		eItem.DROPPED, eItem.GRABBABLE:
			# Synchronizing the floating animation with the drop shadow
			var height: float = sin(current_time * ((2 * PI) / animation_length))
			offset.y = height * float_amount
			current_time += delta

# Checking if object has been interacted with
func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("interact"):
		if state == eItem.GRABBABLE:
			visible = false
			audio.play()
			yield(audio, "finished")
			Helpers.call_error_function(Helpers, "add_item", [self])
			active()

# State transition to grabbable
func grabbable() -> void:
	interact_label.visible = true
	state = eItem.GRABBABLE

# State transition to dropped
func dropped() -> void:
	interact_label.visible = false
	state = eItem.DROPPED

# State transition to active
func active() -> void:
	interact_label.visible = false
	state = eItem.ACTIVE

# State transition to finish
func finish() -> void:
	state = eItem.FINISHED
	queue_free()
	
# Virtual functions to override for inheriting classes
func _item_initial(_tower: Node2D) -> void:
	pass

func _item_on_fire(_bullet: Node2D) -> void:
	pass

func _item_on_bullet_processed(_bullet: Node2D) -> void:
	pass

func _item_on_hit(_bullet: Node2D, _target: Node2D) -> void:
	pass

# Signal functions waiting for player to enter interactable range of item.
func _on_Area_body_entered(_body):
	if state == eItem.DROPPED:
		grabbable()

func _on_Area_body_exited(_body):
	if state == eItem.GRABBABLE:
		dropped()
