extends Node

# Constants

# Signals
const ENEMY_KILLED = "enemy_killed"
const TOWER_PLACEMENT_CANCELLED = "tower_placement_cancelled"
const TOWER_PLACEMENT_CONFIRMED = "tower_placement_confirmed"
const TIMER_TIMEOUT = "timeout"

# Groups
const ENEMIES = "enemies"
const TOWERS = "towers"
const ITEMS = "items"

# Layers
enum CollisionLayers {
	ALL,
	TOWERS,
	ENEMIES,
	PATH
}

# Resources
onready var BULLET_RESOURCE = preload("res://Nodes/Bullet.tscn")
onready var DAMAGE_NUMBER_RESOURCE = preload("res://Nodes/DamageNumber.tscn")
onready var SPAWNER_RESOURCE = preload("res://Nodes/Spawner.tscn")
onready var ENEMY_PATH_RESOURCE = preload("res://Nodes/EnemyPath.tscn")
onready var TOWER_RESOURCE = preload("res://Nodes/Towers/WeakTower.tscn")
