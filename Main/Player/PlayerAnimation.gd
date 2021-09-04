extends AnimatedSprite

class_name PlayerAnimation


# State
enum ePlayerAnimation { IDLE, BEGIN_MOVE, MOVING, FINISH }
var state: int = ePlayerAnimation.IDLE

# Variables
func _ready():
	# Beginning the player with an idle animation
	idle()
	playing = true
	
	# Connecting signal functions for state transitions from the parent
	var parent = get_parent()
	Helpers.call_error_function(parent, "connect", [Constants.PLAYER_STOP, self, "idle"])
	Helpers.call_error_function(parent, "connect", [Constants.PLAYER_MOVING, self, "begin_move"])
	Helpers.call_error_function(parent, "connect", [Constants.PLAYER_FLIP, self, "flip"])

func _on_Animation_animation_finished():
	match state:
		# If the begin move animation finishes switch to the running animation
		ePlayerAnimation.BEGIN_MOVE:
			move()

# Idle animation
func idle():
	state = ePlayerAnimation.IDLE
	play(Constants.PLAYER_ANIMATION_IDLE)

# Begin move animation (transition animation)
func begin_move():
	state = ePlayerAnimation.BEGIN_MOVE
	play(Constants.PLAYER_ANIMATION_BEGIN_RUN)

# Move animation
func move():
	state = ePlayerAnimation.MOVING
	play(Constants.PLAYER_ANIMATION_RUNNING)

# Flips the sprite to face left or right
func flip():
	flip_h = !flip_h



