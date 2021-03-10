extends Control

# Functions
func Continue() -> void:
	Helpers.call_error_function(get_tree(), "change_scene", ["res://Nodes/Scenes/Test.tscn"])

func NewGame() -> void:
	Continue()

func Options() -> void:
	Helpers.call_error_function(get_tree(), "change_scene", ["res://Nodes/Scenes/Options.tscn"])

func Quit() -> void:
	get_tree().quit()

