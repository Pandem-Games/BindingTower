extends Control

class Resolution:
	var width: int
	var height: int

	func _init(w, h):
		width = w
		height = h

	func to_string():
		return (width as String) + " x " + (height as String)


var all_options = {
	"resolution" : [
		Resolution.new(1920, 1080),
		Resolution.new(1680, 1050),
		Resolution.new(1600, 900),
		Resolution.new(1536, 864),
		Resolution.new(1440, 1080),
		Resolution.new(1400, 1050),
		Resolution.new(1366, 768),
		Resolution.new(1280, 960),
		Resolution.new(1280, 720),
		Resolution.new(1024, 768),
		Resolution.new(1024, 640),
		Resolution.new(1014, 576),
		Resolution.new(800, 600)
	],
	"toggle_ignore_sig" : false
}


# Called when the node enters the scene tree for the first time.
func _ready():
	# Call this to hid ethe other options and just display video options
	Video()
	
	# button setting
	set_resolution_btn(all_options["resolution"])
	set_volume_slider()
	set_borderless_fullscreen_btn()
	set_fullscreen_btn()


func Video():
	$VBoxContainer/Video.set_visible(true);
	$VBoxContainer/Audio.set_visible(false);
	$VBoxContainer/Controls.set_visible(false);


func Audio():
	$VBoxContainer/Video.set_visible(false);
	$VBoxContainer/Audio.set_visible(true);
	$VBoxContainer/Controls.set_visible(false);


func Controls():
	$VBoxContainer/Video.set_visible(false);
	$VBoxContainer/Audio.set_visible(false);
	$VBoxContainer/Controls.set_visible(true);


func Back():
	get_tree().change_scene("res://Nodes/Scenes/Menu/TitleScreen.tscn")


func set_resolution_btn(item):
	var counter = 0
	
	for i in item:
		$VBoxContainer/Video/btn_resolution.add_item(i.to_string(), counter)
		if Settings.settings["res_width"] == i.width and Settings.settings["res_height"] == i.height:
			$VBoxContainer/Video/btn_resolution.selected = counter
		counter += 1


func resolution_selected(item_id):
	var resolution = all_options["resolution"][item_id]
	Settings.set_resolution(resolution.width, resolution.height)
	Settings.save_game()


func volume_slider_changed(value, slider_name):
	Settings.set_volume(value, slider_name)
	get_node("VBoxContainer/Audio/lab_" + slider_name + "_number").set_text(str(value))


func set_volume_slider():
	# Updates the number at the end of the slider
	volume_slider_changed(Settings.settings["Master_Volume"], "Master")
	volume_slider_changed(Settings.settings["Music_Volume"], "Music")
	volume_slider_changed(Settings.settings["Effects_Volume"], "Effects")
	
	# Sets the slider value
	$VBoxContainer/Audio/master_volume_slider.value = float(Settings.settings["Master_Volume"])
	$VBoxContainer/Audio/music_volume_slider.value = float(Settings.settings["Music_Volume"])
	$VBoxContainer/Audio/effects_volume_slider.value = float(Settings.settings["Effects_Volume"])


func set_fullscreen_btn():
	if Settings.settings["borderless"] == false:
		if Settings.settings["fullscreen"] == true:
			all_options["toggle_ignore_sig"] = true
			$VBoxContainer/Video/btn_fullscreen.set_pressed(true)


func set_borderless_fullscreen_btn():
	if Settings.settings["borderless"] == true and Settings.settings["fullscreen"] == true:
		all_options["toggle_ignore_sig"] = true
		$VBoxContainer/Video/btn_borderless_fullscreen.set_pressed(true)


func fullscreen_selected(value):
	if all_options["toggle_ignore_sig"] == true:
		all_options["toggle_ignore_sig"] = false
		return
	
	all_options["toggle_ignore_sig"] = true
	$VBoxContainer/Video/btn_borderless_fullscreen.set_pressed(false)
	
	Settings.set_borderless(false)
	Settings.set_fullscreen(value)
	
	all_options["toggle_ignore_sig"] = false


func borderless_fullscreen_selected(value):
	if all_options["toggle_ignore_sig"] == true:
		all_options["toggle_ignore_sig"] = false
		return
	
	all_options["toggle_ignore_sig"] = true
	$VBoxContainer/Video/btn_fullscreen.set_pressed(false)
	
	Settings.set_borderless(value)
	Settings.set_fullscreen(value)
	
	all_options["toggle_ignore_sig"] = false
