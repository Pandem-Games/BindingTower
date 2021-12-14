extends Control

# Functions
func Continue() -> void:
	Helpers.call_error_function(get_tree(), "change_scene", [Constants.main_scene])

func NewGame() -> void:
	Continue()

func Options() -> void:
	Helpers.call_error_function(get_tree(), "change_scene", [Constants.option_scene])

func Quit() -> void:
	get_tree().quit()
	
