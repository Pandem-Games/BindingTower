extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func Continue():
	Helpers.call_error_function(get_tree(), "change_scene", ["res://Nodes/Scenes/Test.tscn"])
	pass


func NewGame():
	Continue()


func Options():
	Helpers.call_error_function(get_tree(), "change_scene", ["res://Nodes/Scenes/Options.tscn"])
	pass


func Quit():
	get_tree().quit()
	pass
