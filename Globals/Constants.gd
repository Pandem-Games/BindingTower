extends Node

# Constants

# Signals
const ENEMY_FINISHED = "enemy_finished"
const ENEMY_SPAWNED = "enemy_spawned"
const ENEMY_KILLED = "enemy_killed"
const TOWER_PLACEMENT_CANCELLED = "tower_placement_cancelled"
const TOWER_PLACEMENT_CONFIRMED = "tower_placement_confirmed"


# Groups
const ENEMIES = "enemies"

# Layers
enum CollisionLayers {
	MISC,
	TOWERS,
	ENEMIES,
	PATH
}
