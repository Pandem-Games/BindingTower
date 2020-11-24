extends Control

func Continue():
	get_tree().change_scene("res://Nodes/Scenes/Test.tscn")

func NewGame():
	Continue()

func Options():
	get_tree().change_scene("res://Nodes/Scenes/Options.tscn")

func Quit():
	get_tree().quit()
