extends Control

# Signals
signal tower_placement_cancelled

# State
enum eTowerButton {WAIT, SELECTED, FINISH}
var state: int = eTowerButton.WAIT

# Variables
export(PackedScene) var tower_resource

# Functions
func _ready():
	state = eTowerButton.WAIT
	
# Used when the tower is selected by the user
func select():
	# Instantiating tower
	var tower: Sprite = tower_resource.instance()
	Helpers.get_main_node().add_child(tower)
	
	# Connecting relevant signals from the tower to the tower button
	Helpers.call_error_function(self, "connect", [Constants.TOWER_PLACEMENT_CANCELLED, tower, "_on_Tower_placement_cancelled"])
	
	Helpers.call_error_function(tower, "connect", [Constants.TOWER_PLACEMENT_CONFIRMED, self, "_on_Tower_placement_confirmed"])
	
	Helpers.call_error_function(tower.get_node("TowerControl"), "connect", ["gui_input", self, "_on_Tower_gui_input"])
	
	state = eTowerButton.SELECTED

# Used to detect when user has clicked the button
func _on_Tower_gui_input(event: InputEvent):
	print("1")
	# This event is also raised by the tower when the user clicks so we have to 
	# check that the user is clicking on the tower button
	print(str(event.is_action_pressed("ui_select")))
	print(str(get_rect().has_point(get_local_mouse_position())))
	if event.is_action_pressed("ui_select") and get_rect().has_point(get_local_mouse_position()):
		print("5")
		match state:
			# The user is clicking on the tower button, initiating the selection
			eTowerButton.WAIT:
				select()
				accept_event()
				print("2")
			# The user is clicking on the tower button again, cancelling the selection
			eTowerButton.SELECTED:
				emit_signal(Constants.TOWER_PLACEMENT_CANCELLED)
				state = eTowerButton.WAIT
				accept_event()
				print("3")
	print("4")

# Called when a tower is placed successfully, which resets the tower button
func _on_Tower_placement_confirmed():
	if state == eTowerButton.SELECTED:
		state = eTowerButton.WAIT
