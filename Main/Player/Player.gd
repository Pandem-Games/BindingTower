extends KinematicBody2D

class_name Player

# Constants
enum Orientation {Left, Right}

# Signals
signal player_moving
signal player_flip
signal player_stop

# State
enum ePlayer { WAIT, BEGIN_MOVE, MOVING, FINISH }
var state: int = ePlayer.WAIT

# Variables
export(float) var top_running_speed := 20000.0
# Percent of top speed
export(float, 0.0, 1.0) var initial_speed_percentage := 0.2
# Number of seconds it takes to accelerate
export(float) var acceleration_period := 0.2
# The ease function used to transition the speed
export(float, EASE) var transition_speed := 0.615

var velocity := Vector2()
var velocity_percentage := 0.0
var orientation: int = Orientation.Right

# Functions

# Wait state for character waiting for input
func wait():
	velocity_percentage = 0.0
	state = ePlayer.WAIT
	emit_signal(Constants.PLAYER_STOP)

# Begin move state that eases character movement gradually
func begin_move(v, delta):
	velocity_percentage += delta / acceleration_period
	
	if velocity_percentage >= 1.0:
		state = ePlayer.MOVING
		move(v, delta)
	else:
		velocity = move_and_slide(v * delta * lerp(initial_speed_percentage, 1, ease(velocity_percentage, transition_speed)))

# Move state when character has reached top speed
func move(v, delta):
	velocity = move_and_slide(v * delta)
	
func _physics_process(delta):
	# Obtaining directional vector for character movement
	velocity = Vector2()
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	velocity = velocity.normalized() * top_running_speed
	
	# If the player is changing directions (between left and right) then flip the player sprite
	if velocity.x > 0 and orientation != Orientation.Right:
		emit_signal(Constants.PLAYER_FLIP)
		orientation = Orientation.Right
	elif velocity.x < 0 and orientation != Orientation.Left:
		emit_signal(Constants.PLAYER_FLIP)
		orientation = Orientation.Left
	
	# State transitions
	match state:
		ePlayer.WAIT:
			if velocity.length() > 0:
				emit_signal(Constants.PLAYER_MOVING)
				state = ePlayer.BEGIN_MOVE
				begin_move(velocity, delta)
		ePlayer.BEGIN_MOVE:
			if velocity.length() > 0:
				begin_move(velocity, delta)
			else:
				wait()
		ePlayer.MOVING:
			if velocity.length() > 0:
				move(velocity, delta)
			else:
				wait()
