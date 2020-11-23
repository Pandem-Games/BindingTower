extends Control


var all_options = {
	"Resolution" : {
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
#	"Fullscreen" : {
#		"fullscreen" : "fullscreen",
#		"windowed" : "windowed",
#		"boarderless" : "boarderless"
#	}

}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Call this to hid ethe other options and just display video options
	Video()

	for i in all_options:
		call(i, all_options[i])

	set_volume()


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


func Resolution(item):
	var counter = 0

	for i in item:
		$VBoxContainer/Video/btn_resolution.add_item(i, counter)

		if Settings.settings["res_width"] == all_options["Resolution"][i]["width"] and Settings.settings["res_height"] == all_options["Resolution"][i]["height"]:
			$VBoxContainer/Video/btn_resolution.selected = counter

		counter += 1


func resolution_selected(item_id):
	var key = all_options["Resolution"].keys()[item_id]
	Settings.set_resolution(all_options["Resolution"][key]["width"], all_options["Resolution"][key]["height"])
	Settings.save_game()


func Fullscreen(item):
	var counter = 0

	for i in item:
		$VBoxContainer/Video/btn_fullscreen.add_item(i, counter)
		counter += 1


func volume_slider_changed(value, slider_name):
	Settings.set_volume(value, slider_name)
	get_node("VBoxContainer/Audio/lab_" + slider_name + "_number").set_text(str(value))



func set_volume():
	volume_slider_changed(Settings.settings["Master_Volume"], "Master")
	volume_slider_changed(Settings.settings["Music_Volume"], "Music")
	volume_slider_changed(Settings.settings["Effects_Volume"], "Effects")
	$VBoxContainer/Audio/master_volume_slider.value = float(Settings.settings["Master_Volume"])
	$VBoxContainer/Audio/music_volume_slider.value = float(Settings.settings["Music_Volume"])
	$VBoxContainer/Audio/effects_volume_slider.value = float(Settings.settings["Effects_Volume"])
