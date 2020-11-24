extends Node2D

class_name DamageNumber

# Variables
onready var label := $DamageNumber
var text: String
var label_position: Vector2

# Functions

# Signal function called when the timer finishes
func _on_Timer_timeout():
	queue_free()

# Initializes values for the node
func init(damage, global_position):
	text = str(damage)
	label_position = global_position

func _ready():
	label.text = text
	label.rect_position = label_position
