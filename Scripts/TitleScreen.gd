extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func Continue():
	get_tree().change_scene("res://Nodes/Scenes/Test.tscn")
	pass


func NewGame():
	Continue()


func Options():
	get_tree().change_scene("res://Nodes/Scenes/Options.tscn")
	pass


func Quit():
	get_tree().quit()
	pass
