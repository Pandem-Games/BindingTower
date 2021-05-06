extends Button

enum eButton { ONHOVER, FINISHED}
var state = eButton.FINISHED


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Helpers.call_error_function(self, "connect", ["mouse_entered", self, "change_color_state", [eButton, eButton.ONHOVER]])
	Helpers.call_error_function(self, "connect", ["mouse_exited", self, "change_color_state", [eButton, eButton.FINISHED]])


func change_color_state(state_given, changed_state) -> void:
	match changed_state:
		state_given.ONHOVER:
			# change the color to yellow
			pass
		
		state_given.FINISHED:
			# return color back to normal
			pass

func change_state() -> void:
	pass
