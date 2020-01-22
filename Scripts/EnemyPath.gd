extends Node2D

# Constants

# Signals

# State

# Variables
var curve: Curve2D

func init(c):
	self.curve = c

# Called when the node enters the scene tree for the first time.
func _ready():
	$Path.curve = curve

func _on_Follow_enemy_killed():
	queue_free()
