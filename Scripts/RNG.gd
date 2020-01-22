extends Node

# Constants
const presetSeed = 12344

# Variables
var G = RandomNumberGenerator.new()

func _init():
	G.seed = presetSeed
