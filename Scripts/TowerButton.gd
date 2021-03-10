extends Control

# Signals
signal tower_placement_cancelled

# State
enum eTowerButton {WAIT, SELECTED, FINISH}
var state: int = eTowerButton.WAIT

# Variables
#export(PackedScene) var tower_resource

# Functions
func _ready() -> void:
	state = eTowerButton.WAIT
	
# Used when the tower is selected by the user
func select() -> void:
	# Instantiating tower
	var tower: Sprite = Constants.TOWER_RESOURCE.instance()
	Helpers.get_main_node().add_child(tower)
	
	# Connecting relevant signals from the tower to the tower button
	Helpers.call_error_function(self, "connect", [Constants.TOWER_PLACEMENT_CANCELLED, tower, "_on_Tower_placement_cancelled"])
	Helpers.call_error_function(tower, "connect", [Constants.TOWER_PLACEMENT_CONFIRMED, self, "_on_Tower_placement_confirmed"])
	Helpers.call_error_function(tower.get_node("TowerControl"), "connect", ["gui_input", self, "_on_Tower_gui_input"])
	
	state = eTowerButton.SELECTED

# Used to detect when user has clicked the button
func _on_Tower_gui_input(event: InputEvent) -> void:
	# This event is also raised by the tower when the user clicks so we have to 
	# check that the user is clicking on the tower button
	if event.is_action_pressed("ui_select") and get_rect().has_point(get_local_mouse_position()):
		match state:
			# The user is clicking on the tower button, initiating the selection
			eTowerButton.WAIT:
				select()
				accept_event()
			# The user is clicking on the tower button again, cancelling the selection
			eTowerButton.SELECTED:
				emit_signal(Constants.TOWER_PLACEMENT_CANCELLED)
				state = eTowerButton.WAIT
				accept_event()

# Called when a tower is placed successfully, which resets the tower button
func _on_Tower_placement_confirmed() -> void:
	if state == eTowerButton.SELECTED:
		state = eTowerButton.WAIT
