extends Control

class Resolution:
	var width: int
	var height: int

	func _init(w, h)  -> void:
		width = w
		height = h

	func to_string() -> String:
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

# Variables
onready var video_tab: Control = $VBoxContainer/Video
onready var audio_tab: Control = $VBoxContainer/Audio
onready var controls_tab: Control = $VBoxContainer/Controls
onready var title_screen: Control = get_parent().get_node("TitleScreen")

onready var resolution_options: OptionButton = $VBoxContainer/Video/btn_resolution
onready var fullscreen_toggle: CheckBox = $VBoxContainer/Video/btn_fullscreen
onready var borderless_fullscreen_toggle: CheckBox = $VBoxContainer/Video/btn_borderless_fullscreen

onready var master_volume: Control = $VBoxContainer/Audio/master_volume_slider
onready var music_volume: Control = $VBoxContainer/Audio/music_volume_slider
onready var effects_volume: Control = $VBoxContainer/Audio/effects_volume_slider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Call this to hide the other options and just display video options
	video()
	
	# Button Setters
	set_resolution_btn(all_options["resolution"])
	set_volume_slider()
	set_borderless_fullscreen_btn()
	set_fullscreen_btn()


func video() -> void:
	video_tab.set_visible(true);
	audio_tab.set_visible(false);
	controls_tab.set_visible(false);


func audio() -> void:
	video_tab.set_visible(false);
	audio_tab.set_visible(true);
	controls_tab.set_visible(false);


func controls() -> void:
	video_tab.set_visible(false);
	audio_tab.set_visible(false);
	controls_tab.set_visible(true);


func back() -> void:
	visible = false
	title_screen.visible = true

func set_resolution_btn(item: Array) -> void:
	var counter = 0
	
	for i in item:
		resolution_options.add_item(i.to_string(), counter)
		if Settings.settings["res_width"] == i.width and Settings.settings["res_height"] == i.height:
			resolution_options.selected = counter
		counter += 1


func resolution_selected(item_id) -> void:
	var resolution = all_options["resolution"][item_id]
	Settings.set_resolution(resolution.width, resolution.height)
	Settings.save_game()


func volume_slider_changed(value, slider_name) -> void:
	Settings.set_volume(value, slider_name)
	(get_node("VBoxContainer/Audio/lab_" + slider_name + "_number") as Label).set_text(str(value))


func set_volume_slider() -> void:
	# Updates the number at the end of the slider
	volume_slider_changed(Settings.settings["Master_Volume"], "Master")
	volume_slider_changed(Settings.settings["Music_Volume"], "Music")
	volume_slider_changed(Settings.settings["Effects_Volume"], "Effects")
	
	# Sets the slider value
	master_volume.value = float(Settings.settings["Master_Volume"])
	music_volume.value = float(Settings.settings["Music_Volume"])
	effects_volume.value = float(Settings.settings["Effects_Volume"])


func set_fullscreen_btn() -> void:
	if Settings.settings["borderless"] == false:
		if Settings.settings["fullscreen"] == true:
			all_options["toggle_ignore_sig"] = true
			fullscreen_toggle.set_pressed(true)


func set_borderless_fullscreen_btn() -> void:
	if Settings.settings["borderless"] == true and Settings.settings["fullscreen"] == true:
		all_options["toggle_ignore_sig"] = true
		borderless_fullscreen_toggle.set_pressed(true)


func fullscreen_selected(value) -> void:
	if all_options["toggle_ignore_sig"] == true:
		all_options["toggle_ignore_sig"] = false
		return
	
	all_options["toggle_ignore_sig"] = true
	borderless_fullscreen_toggle.set_pressed(false)
	
	Settings.set_borderless(false)
	Settings.set_fullscreen(value)
	
	all_options["toggle_ignore_sig"] = false


func borderless_fullscreen_selected(value) -> void:
	if all_options["toggle_ignore_sig"] == true:
		all_options["toggle_ignore_sig"] = false
		return
	
	all_options["toggle_ignore_sig"] = true
	fullscreen_toggle.set_pressed(false)
	
	Settings.set_borderless(value)
	Settings.set_fullscreen(value)
	
	all_options["toggle_ignore_sig"] = false
