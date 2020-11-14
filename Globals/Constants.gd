extends Node

# Constants

# Signals
const ENEMY_FINISHED = "enemy_finished"
const ENEMY_SPAWNED = "enemy_spawned"
const ENEMY_KILLED = "enemy_killed"

# Groups
const ENEMIES = "enemies"

# Layers
enum CollisionLayers {
	MISC,
	TOWERS,
	ENEMIES,
	PATH
}
