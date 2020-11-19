extends Node

# Constants
const presetSeed = 12344

# Variables
var G = RandomNumberGenerator.new()

# Functions
func _init():
	G.seed = presetSeed
