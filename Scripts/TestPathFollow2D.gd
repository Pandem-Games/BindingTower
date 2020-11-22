extends PathFollow2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed: float

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	set_offset(get_offset() + speed)
