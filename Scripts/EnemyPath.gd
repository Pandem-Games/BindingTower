extends Node2D

# Variables
var curve: Curve2D

# Functions

# Used to initialize the node
func init(c: Curve2D):
	self.curve = c

# Called when the node enters the scene tree for the first time.
func _ready():
	$Path.curve = curve

# Signal function called when the enemy is killed
func _on_Follow_enemy_killed():
	queue_free()
