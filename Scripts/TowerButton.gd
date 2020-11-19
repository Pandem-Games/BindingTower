extends Control

# Signals
signal tower_placement_cancelled

# State
enum eTowerButton {WAIT, SELECTED, FINISH}
var state = eTowerButton.WAIT

# Variables
export(PackedScene) var tower_resource

# Functions
func _ready():
	state = eTowerButton.WAIT
	print("Button.Wait3")
	
func select():
	var tower: Sprite = tower_resource.instance()
	Helpers.get_main_node().add_child(tower)
	var error: int = connect(Constants.TOWER_PLACEMENT_CANCELLED, tower, "_on_Tower_placement_cancelled")
	if error != OK:
		print("Error {", error, "} connecting signal: ", Constants.TOWER_PLACEMENT_CANCELLED)
	
	error = tower.connect(Constants.TOWER_PLACEMENT_CONFIRMED, self, "_on_Tower_placement_confirmed")
	if error != OK:
		print("Error {", error, "} connecting signal: ", Constants.TOWER_PLACEMENT_CONFIRMED)
	
	state = eTowerButton.SELECTED
	print("Button.Selected")

func _unhandled_input(_event):
#	if state == eTowerButton.SELECTED and event.is_action_pressed("ui_select"):
#		for area in tower_areas:
#			area.visible = false
#		state = eTowerButton.WAIT
#		accept_event()
	pass

func _on_Tower_gui_input(event: InputEvent):
	if event.is_action_pressed("ui_select"):
		print("Selected")
		match state:
			eTowerButton.SELECTED:
				emit_signal(Constants.TOWER_PLACEMENT_CANCELLED)
				state = eTowerButton.WAIT
				print("Button.Wait")
			eTowerButton.WAIT:
				select()
		accept_event()

func _on_Tower_placement_confirmed():
	if state == eTowerButton.SELECTED:
		state = eTowerButton.WAIT
		print("Button.Wait2")
