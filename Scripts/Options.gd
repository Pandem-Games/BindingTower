extends Control


var all_options = {
	"resolution" : {
		"1920 x 1080" : {
			"width" : 1920,
			"height" : 1080
		},
		"1680 x 1050" : {
			"width" : 1680,
			"height" : 1050
		},
		"1600 x 900" : {
			"width" : 1600,
			"height" : 900
		},
		"1536 x 864" : {
			"width" : 1536,
			"height" : 864
		},
		"1440 x 1080" : {
			"width" : 1440,
			"height" : 1080
		},
		"1400 x 1050" : {
			"width" : 1400,
			"height" : 1050
		},
		"1366 x 768" : {
			"width" : 1366,
			"height" : 768
		},
		"1280 x 960" : {
			"width" : 1280,
			"height" : 960
		},
		"1280 x 720" : {
			"width" : 1280,
			"height" : 720
		},
		"1024 x 768" : {
			"width" : 1024,
			"height" : 768
		},
		"1024 x 640" : {
			"width" : 1024,
			"height" : 640
		},
		"1014 x 576" : {
			"width" : 1014,
			"height" : 576
		},
		"800 x 600" : {
			"width" : 800,
			"height" : 600
		}
	},
	"toggle_ignore_sig" : false
}

# Variables
onready var video_tab: Control = $VBoxContainer/Video
onready var audio_tab: Control = $VBoxContainer/Audio
onready var controls_tab: Control = $VBoxContainer/Controls

onready var resolution_options: OptionButton = $VBoxContainer/Video/btn_resolution
onready var fullscreen_toggle: CheckBox = $VBoxContainer/Video/btn_fullscreen
onready var borderless_fullscreen_toggle: CheckBox = $VBoxContainer/Video/btn_borderless_fullscreen

onready var master_volume: Control = $VBoxContainer/Audio/master_volume_slider
onready var music_volume: Control = $VBoxContainer/Audio/music_volume_slider
onready var effects_volume: Control = $VBoxContainer/Audio/effects_volume_slider

# Called when the node enters the scene tree for the first time.
func _ready():
	# Call this to hid ethe other options and just display video options
	Video()
	
	set_resolution_btn(all_options["resolution"])
	
	# call() can call a function by using a string
#	for i in all_options:
		#call("set_" + i + "_btn", all_options[i])
	
	set_volume_slider()
	set_borderless_fullscreen_btn()
	set_fullscreen_btn()


func Video():
	video_tab.set_visible(true);
	audio_tab.set_visible(false);
	controls_tab.set_visible(false);


func Audio():
	video_tab.set_visible(false);
	audio_tab.set_visible(true);
	controls_tab.set_visible(false);


func Controls():
	video_tab.set_visible(false);
	audio_tab.set_visible(false);
	controls_tab.set_visible(true);


func Back():
	Helpers.call_error_function(get_tree(), "change_scene", ["res://Nodes/Scenes/Menu/TitleScreen.tscn"])


func set_resolution_btn(item):
	var counter = 0
	
	for i in item:
		resolution_options.add_item(i, counter)
		if Settings.settings["res_width"] == all_options["resolution"][i]["width"] and Settings.settings["res_height"] == all_options["resolution"][i]["height"]:
			resolution_options.selected = counter
		counter += 1


func resolution_selected(item_id):
	var key = all_options["resolution"].keys()[item_id]
	Settings.set_resolution(all_options["resolution"][key]["width"], all_options["resolution"][key]["height"])
	Settings.save_game()


func volume_slider_changed(value, slider_name):
	Settings.set_volume(value, slider_name)
	(get_node("VBoxContainer/Audio/lab_" + slider_name + "_number") as Label).set_text(str(value))


func set_volume_slider():
	# Updates the number at the end of the slider
	volume_slider_changed(Settings.settings["Master_Volume"], "Master")
	volume_slider_changed(Settings.settings["Music_Volume"], "Music")
	volume_slider_changed(Settings.settings["Effects_Volume"], "Effects")
	
	# Sets the slider value
	master_volume.value = float(Settings.settings["Master_Volume"])
	music_volume.value = float(Settings.settings["Music_Volume"])
	effects_volume.value = float(Settings.settings["Effects_Volume"])


func set_fullscreen_btn():
	if Settings.settings["borderless"] == false:
		if Settings.settings["fullscreen"] == true:
			all_options["toggle_ignore_sig"] = true
			fullscreen_toggle.set_pressed(true)
#			all_options["toggle_fullscreen"] = true


func set_borderless_fullscreen_btn():
	if Settings.settings["borderless"] == true and Settings.settings["fullscreen"] == true:
		all_options["toggle_ignore_sig"] = true
		borderless_fullscreen_toggle.set_pressed(true)
#		all_options["toggle_borderless_fullscreen"] = true


func fullscreen_selected(value):
	if all_options["toggle_ignore_sig"] == true:
		all_options["toggle_ignore_sig"] = false
		return
	
	all_options["toggle_ignore_sig"] = true
	borderless_fullscreen_toggle.set_pressed(false)
	
	Settings.set_borderless(false)
	Settings.set_fullscreen(value)
	
	all_options["toggle_ignore_sig"] = false


func borderless_fullscreen_selected(value):
	if all_options["toggle_ignore_sig"] == true:
		all_options["toggle_ignore_sig"] = false
		return
	
	all_options["toggle_ignore_sig"] = true
	fullscreen_toggle.set_pressed(false)
	
	Settings.set_borderless(value)
	Settings.set_fullscreen(value)
	
	all_options["toggle_ignore_sig"] = false
