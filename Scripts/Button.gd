extends Button

enum eButton { ONHOVER, FINISHED}
var state = eButton.FINISHED
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("mouse_entered", self, "change_color_state", [eButton, eButton.ONHOVER])
	self.connect("mouse_exited", self, "change_color_state", [eButton, eButton.FINISHED])
	
	#$MarginContainer/HBoxContainer/Menu/btn_back.connect("mouse_entered", self, "change_color_state", [eButton, eButton.ONHOVER])
	#$MarginContainer/HBoxContainer/Menu/btn_video.connect("mouse_exited", self, "change_color_state", [eButton, eButton.FINISHED])

func change_color_state(state_given, changed_state):
	#print(state_given)
	match changed_state:
		state_given.ONHOVER:
			# change the color to yellow
			# print("onhover")
			pass
		
		state_given.FINISHED:
			# return color back to normal
			# print("finished")
			pass
	pass

func change_state():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
