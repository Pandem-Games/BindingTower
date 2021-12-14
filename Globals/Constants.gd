extends Node

# Constants

# Signals
const ENEMY_KILLED = "enemy_killed"
const ENEMY_FINISHED = "enemy_finished"
const TOWER_PLACEMENT_CANCELLED = "tower_placement_cancelled"
const TOWER_PLACEMENT_CONFIRMED = "tower_placement_confirmed"
const TIMER_TIMEOUT = "timeout"
const PLAYER_MOVING = "player_moving"
const PLAYER_FLIP = "player_flip"
const PLAYER_STOP = "player_stop"

# Groups
const ENEMIES = "enemies"
const TOWERS = "towers"
const ITEMS = "items"

# Layers
enum CollisionLayers {
	ALL,
	TOWERS,
	ENEMIES,
	PATH,
	PLAYER,
	INTERACTABLE
}

# Resources
onready var BULLET_RESOURCE = preload("res://Main/Bullet/Bullet.tscn")
onready var DAMAGE_NUMBER_RESOURCE = preload("res://UI/DamageNumber/DamageNumber.tscn")
onready var SPAWNER_RESOURCE = preload("res://Main/Spawner/Spawner.tscn")
onready var ENEMY_PATH_RESOURCE = preload("res://Main/Enemy/EnemyPath.tscn")
onready var TOWER_RESOURCE = preload("res://Main/Tower/WeakTower/WeakTower.tscn")

# Animations
const PLAYER_ANIMATION_IDLE = "Idle"
const PLAYER_ANIMATION_BEGIN_RUN = "BeginRun"
const PLAYER_ANIMATION_RUNNING = "Running"
