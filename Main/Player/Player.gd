extends KinematicBody2D

class_name Player

# Constants

# Signals

# State
enum ePlayer { WAIT, BEGIN_MOVE, MOVING, FINISH }
var state: int = ePlayer.WAIT

# Variables
export(float) var speed = 10000.0
var velocity = Vector2()

# Functions
func wait():
	state = ePlayer.WAIT
	
func begin_move(v, delta):
	velocity = move_and_slide(v * delta)
	
func move(v, delta):
	velocity = move_and_slide(v * delta)
	
func _process(delta):
	velocity = Vector2()
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	velocity = velocity.normalized() * speed
	
	
	match state:
		ePlayer.WAIT:
			if velocity.length() > 0:
				state = ePlayer.MOVING
				move(velocity, delta)
#		ePlayer.BEGIN_MOVE:
#			if velocity.length() > 0:
#				begin_move(velocity, delta)
#			else:
#				wait()
		ePlayer.MOVING:
			if velocity.length() > 0:
				move(velocity, delta)
			else:
				wait()
