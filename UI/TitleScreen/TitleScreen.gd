extends Control

onready var options := get_parent().get_node("Options")

# Functions
func Continue() -> void:
	Helpers.call_error_function(get_tree(), "change_scene", [Constants.main_scene])

func NewGame() -> void:
	Continue()

func Options() -> void:
	visible = false
	options.visible = true

func Quit() -> void:
	get_tree().quit()
	
