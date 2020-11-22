extends Control

enum eContinue { ONHOVER, FINISHED}
enum eNewGame { ONHOVER, FINISHED}
enum eOptions { ONHOVER, FINISHED}
enum eQuit { ONHOVER, FINISHED}
var state = eContinue.FINISHED

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/Menu/btn_continue.connect("pressed", self, "Continue")
	$MarginContainer/HBoxContainer/Menu/btn_newGame.connect("pressed", self, "NewGame")
	$MarginContainer/HBoxContainer/Menu/btn_options.connect("pressed", self, "Options")
	$MarginContainer/HBoxContainer/Menu/btn_quit.connect("pressed", self, "Quit")
	
	#$MarginContainer/HBoxContainer/Menu/btn_continue.connect("mouse_entered", self, "change_color_state", [eContinue, eContinue.ONHOVER])
	#$MarginContainer/HBoxContainer/Menu/btn_newGame.connect("mouse_entered", self, "change_color_state", [eNewGame, eNewGame.ONHOVER])
	#$MarginContainer/HBoxContainer/Menu/btn_options.connect("mouse_entered", self, "change_color_state", [eOptions, eOptions.ONHOVER])
	#$MarginContainer/HBoxContainer/Menu/btn_quit.connect("mouse_entered", self, "change_color_state", [eQuit, eQuit.ONHOVER])
	
	#$MarginContainer/HBoxContainer/Menu/btn_continue.connect("mouse_exited", self, "change_color_state", [eContinue, eContinue.FINISHED])
	#$MarginContainer/HBoxContainer/Menu/btn_newGame.connect("mouse_exited", self, "change_color_state", [eNewGame, eNewGame.FINISHED])
	#$MarginContainer/HBoxContainer/Menu/btn_options.connect("mouse_exited", self, "change_color_state", [eOptions, eOptions.FINISHED])
	#$MarginContainer/HBoxContainer/Menu/btn_quit.connect("mouse_exited", self, "change_color_state", [eQuit, eQuit.FINISHED])
	
	pass # Replace with function body.

func change_color_state(state_given, changed_state):
	#print(state_given)
	match changed_state:
		state_given.ONHOVER:
			print("onhover")
			#change the color to yellow
		
		state_given.FINISHED:
			print("finished")
			# return color back to normal
	pass

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

