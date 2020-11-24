extends Control

# Functions
func Continue():
	Helpers.call_error_function(get_tree(), "change_scene", ["res://Nodes/Scenes/Test.tscn"])

func NewGame():
	Continue()

func Options():
	Helpers.call_error_function(get_tree(), "change_scene", ["res://Nodes/Scenes/Options.tscn"])

func Quit():
	get_tree().quit()
