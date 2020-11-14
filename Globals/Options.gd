extends Control

# Temporary
const SAVE_PATH = "res://save.json"
var settings = {}

var play_Music = 1 # How loud the music is based on master volume and music volume
var play_Effects = 1 # How loud the effects is based on master volume and effects volume

var new_choice = 1 # Choose what music is playing

var song # Song playing

var menu = true # Choose wheather to play game music or menu music

# Saved
# Volume - 1 is lowest and 2000 is max
var Master_Volume = 2000
var Music_Volume = 2000
var Effects_Volume = 2000

# Mute - true or false
var Master_Mute = false
var Music_Mute = false
var Effects_Mute = false

# Resolution
var res_width = 1920
var res_height = 1080

var fullscreen = false

#Scan Codes - keyboard inputs that are binded to an action
var kb_use = 32 #space bar
var kb_pause = 16777217 #escape

func _ready():
	# See any variables that aren't defaulted need to be changed instantly aka resolution. 
	# The default will selected every time otherwise.
	load_game()
	save_game()
	choose_music()
	resolution()
	pass 

# If user wants to change the input for an action
func _input(kb_change):
	pass


func _process(delta):
	if(!$music.is_playing()):
		choose_music()

	if(Master_Volume > 0 && Music_Volume > 0):
		play_Music = int((Master_Volume / 2000) * (Music_Volume / 2000) * 2000)
	else:
		play_Music = 1

	$music.set_max_distance(play_Music)

	if(Master_Volume > 0 && Effects_Volume > 0):
		play_Effects = int((Master_Volume / 2000) * (Effects_Volume / 2000) * 2000)
	else:
		play_Effects = 1

	$music.set_max_distance(play_Effects)
	pass


# Choose the music to play
func choose_music():
	#if(menu == true):
		#menu_music()
	#else:
		#game_music()
	
	match menu:
		true:
			menu_music()
		false:
			game_music()
	pass

# Play and set variables to play just menu music
func menu_music():
	#inits the randomizer
	randomize()
	
	#chooses the songs
	new_choice =  int(rand_range(1,1))
	
	#loads in songs
	match new_choice:
		1:
			song = load("res://Assests/Music/BoxCat_Games_-_16_-_Love_Of_My_Life.wav")
		2:
			pass
	
	$music.set_stream(song)
	$music.play(0.0)
	
	pass

# Play game music and set up what playlist to go off on
func game_music():
	#inits the randomizer
	randomize()
	
	#chooses the songs
	new_choice =  int(rand_range(1,1))
	
	#loads in songs
	match new_choice:
		1:
			song = load("res://Assests/Music/BoxCat_Games_-_16_-_Love_Of_My_Life.wav")
		2:
			pass
	
	$music.set_stream(song)
	$music.play(0.0)
	
	pass

# Set or change resolution
func resolution():
	ProjectSettings.set_setting("display/window/size/width", res_width)
	ProjectSettings.set_setting("display/window/size/height", res_height)
	OS.set_window_size(Vector2(res_width, res_height))
	
	if(fullscreen == true):
		OS.set_window_fullscreen(false)
		OS.set_window_fullscreen(true)
	elif(fullscreen == false):
		OS.set_window_fullscreen(true)
		OS.set_window_fullscreen(false)
		OS.set_window_position(Vector2(0,0))
	pass


# Save variables of current progress
func save_game():
	var settings = {
		resolution = {
			width = res_width,
			height = res_height
		},
		fullscreen = fullscreen,
		Master_Volume = Master_Volume,
		Master_Mute = Master_Mute,
		Music_Volume = Music_Volume,
		Music_Mute = Music_Mute,
		Effects_Volume = Effects_Volume,
		Effects_Mute = Effects_Mute,
		
		#controls
		kb_use = kb_use,
		kb_pasue = kb_pause
	}
	
	#Saving
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	save_file.store_line(to_json(settings))
	save_file.close()
	
	pass

# Based on variables set up the level
func load_game():
	pass

