extends Control

# Temporary
const SAVE_PATH = "res://save.json"

# Only ogg and wav files - wav is much bigger
var menu_music = [
	"res://UI/TitleScreen/TitleScreen.wav"
]

# Only ogg and wav files
var game_music = [
	"res://UI/TitleScreen/TitleScreen.wav"
]

#this will probably be the version check
var update_settings_check = 1

var settings = {
	"new_choice" : 0, # Choose what music is playing
	
	# Choose wheather to play game music or menu music
	"menu" : true,
	
	# Volume - 1 is lowest and 2000 is max
	"Master_Volume" : 50,
	"Music_Volume" : 50,
	"Effects_Volume" : 50,
	
	# Resolution
	"res_width" : 1920,
	"res_height" : 1080,

	# Window
	"fullscreen" : false,
	"borderless" : false,

	#Scan Codes - keyboard inputs that are binded to an action
	"scan_codes" : {
		"use" : 32, #space bar
		"pause" : 16777217 #escape
	}
}


func _ready():
	# See any variables that aren't defaulted need to be changed instantly aka resolution. 
	# The default will selected every time otherwise.

	# Check if this is the first time the user has opened the game.
		# If so then make a save file.
		### If we take this to steam we might want to download this file to a server. ###
	var check_init_file = File.new()
	
	if(not check_init_file.file_exists(SAVE_PATH)):
		save_game()
	
	check_init_file.close()
	
	# If we update the game I wanted some method to not overwrite the information already there.
	# So this should change update the information.
#	if update_settings_check == 1:
#		update_settings()
	
	load_game()
	set_resolution(settings["res_width"], settings["res_height"])

# If user wants to change the input for an action
#func _input(action, kb_change):
#	InputMap.action_erase_events(action)
#	InputMap.action_add_event(action, kb_change)
#	settings["scan_codes"][action] = kb_change

# If aditional settings are added then make update_settings 1 and it will add to the default setting
func update_settings():
	var save_file = File.new()

	if(not save_file.file_exists(SAVE_PATH)):
		return
	
	save_file.open(SAVE_PATH, File.READ)
	var old_settings = parse_json(save_file.get_as_text())
	save_file.close()
	
	setting_check(old_settings)


func setting_check(old_setting):
	# TODO: Make sure new settings are the basis for the schema
	for index in settings:
		if !old_setting.has(index):
			old_setting[index] = settings[index]
		elif typeof(settings[index]) == 18 or typeof(settings[index]) == 19:
			setting_check(old_setting[index])


func set_volume(volume_value, volume_name):
	settings[volume_name + "_Volume"] = volume_value
	
	# Sets db from 0 to -20	
	var bus_db = ((volume_value / 100) * 20) - 20
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(volume_name), bus_db)
	
	if volume_value == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(volume_name), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(volume_name), false)
	
	save_game()

# Set or change resolution
func set_resolution(resolution_width, resolution_height):
	settings["res_width"] = resolution_width
	settings["res_height"] = resolution_height
	
	ProjectSettings.set_setting("display/window/size/width", settings["res_width"])
	ProjectSettings.set_setting("display/window/size/height", settings["res_height"])
	OS.set_window_size(Vector2(settings["res_width"], settings["res_height"]))
	
	save_game()

func set_fullscreen(value):
	settings["fullscreen"] = value
	OS.set_window_fullscreen(value)
	
	if value == false:
		OS.set_window_position(Vector2(0,0))
	
	save_game()


func set_borderless(value):
	settings["borderless"] = value
	OS.set_borderless_window(value)
	
	save_game()

# Save option variables
func save_game():
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	save_file.store_line(to_json(settings))
	save_file.close()

# Based on variables set up the level
func load_game():
	var save_file = File.new()
	
	if(not save_file.file_exists(SAVE_PATH)):
		return
	
	save_file.open(SAVE_PATH, File.READ)
	settings = parse_json(save_file.get_as_text())
	save_file.close()
	
	set_volume(settings["Master_Volume"], "Master")
	set_volume(settings["Music_Volume"], "Music")
	set_volume(settings["Effects_Volume"], "Effects")
	set_fullscreen(settings["fullscreen"])
	set_borderless(settings["borderless"])
