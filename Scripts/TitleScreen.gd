extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/Menu/btn_continue.connect("pressed", self, "Continue")
	$MarginContainer/HBoxContainer/Menu/btn_newGame.connect("pressed", self, "NewGame")
	$MarginContainer/HBoxContainer/Menu/btn_options.connect("pressed", self, "Options")
	$MarginContainer/HBoxContainer/Menu/btn_quit.connect("pressed", self, "Quit")
	pass # Replace with function body.


func Continue():
	get_tree().change_scene("res://Nodes/Scenes/Test.tscn")
	pass

func NewGame():
	Continue()

func Options():
	pass

func Quit():
	get_tree().quit()
	pass

