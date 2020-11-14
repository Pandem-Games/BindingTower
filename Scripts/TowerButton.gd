extends Control

# State
enum eTowerButton {WAIT, SELECTED, RESTRICTED, FINISH}
var state = eTowerButton.WAIT

# Variables
export(PackedScene) var tower_resource

# Functions
func _ready():
	state = eTowerButton.WAIT

func _unhandled_input(event):
#	if state == eTowerButton.SELECTED and event.is_action_pressed("ui_select"):
#		for area in tower_areas:
#			area.visible = false
#		state = eTowerButton.WAIT
#		accept_event()
	pass

func _on_Tower_gui_input(event: InputEvent):
	if event.is_action_pressed("ui_select"):
		match state:
			eTowerButton.SELECTED, eTowerButton.RESTRICTED:
				state = eTowerButton.WAIT
			eTowerButton.WAIT:
				state = eTowerButton.SELECTED
		accept_event()
