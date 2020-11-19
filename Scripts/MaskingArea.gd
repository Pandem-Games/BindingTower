extends CollisionPolygon2D

# State
enum eMaskingArea {DRAWING, FINISH}
var state = eMaskingArea.DRAWING

# Functions
func draw():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	state = eMaskingArea.DRAWING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match state:
		eMaskingArea.DRAWING:
			draw()
