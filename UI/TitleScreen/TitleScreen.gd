extends Control

# Functions
func Continue() -> void:
	Helpers.call_error_function(get_tree(), "change_scene", ["res://Main/Test/Test.tscn"])

func NewGame() -> void:
	Continue()

func Options() -> void:
	Helpers.call_error_function(get_tree(), "change_scene", ["res://UI/Options/Options.tscn"])

func Quit() -> void:
	get_tree().quit()
	
