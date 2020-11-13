extends Control

enum eVideo { ONHOVER, FINISHED}
enum eAudio { ONHOVER, FINISHED}
enum eControls { ONHOVER, INISHED}
enum eBack { ONHOVER, FINISHED}
var state = eVideo.FINISHED

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/btn_video.connect("pressed", self, "Video")
	$MarginContainer/HBoxContainer/btn_audio.connect("pressed", self, "Audio")
	$MarginContainer/HBoxContainer/btn_controls.connect("pressed", self, "Controls")
	$btn_back.connect("pressed", self, "Back")
	
	#$MarginContainer/HBoxContainer/Menu/btn_video.connect("mouse_entered", self, "change_color_state", [eVideo, eVideo.ONHOVER])
	#$MarginContainer/HBoxContainer/Menu/btn_audio.connect("mouse_entered", self, "change_color_state", [eAudio, eAudio.ONHOVER])
	#$MarginContainer/HBoxContainer/Menu/btn_controls.connect("mouse_entered", self, "change_color_state", [eControls, eControls.ONHOVER])
	#$MarginContainer/HBoxContainer/Menu/btn_back.connect("mouse_entered", self, "change_color_state", [eBack, eBack.ONHOVER])
	
	#$MarginContainer/HBoxContainer/Menu/btn_video.connect("mouse_exited", self, "change_color_state", [eVideo, eVideo.FINISHED])
	#$MarginContainer/HBoxContainer/Menu/btn_audio.connect("mouse_exited", self, "change_color_state", [eAudio, eAudio.FINISHED])
	#$MarginContainer/HBoxContainer/Menu/btn_controls.connect("mouse_exited", self, "change_color_state", [eControls, eControls.FINISHED])
	#$MarginContainer/HBoxContainer/Menu/btn_back.connect("mouse_exited", self, "change_color_state", [eBack, eBack.FINISHED])
	
	pass # Replace with function body.



func Video():
	pass

func Audio():
	pass

func Controls():
	pass

func Back():
	get_tree().change_scene("res://Nodes/Scenes/Menu/TitleScreen.tscn")
	pass

