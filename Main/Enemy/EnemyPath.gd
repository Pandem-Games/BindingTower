extends Node2D

# Variables
var curve: Curve2D

# Functions

# Used to initialize the node
func init(c: Curve2D) -> void:
	self.curve = c

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Path.curve = curve
