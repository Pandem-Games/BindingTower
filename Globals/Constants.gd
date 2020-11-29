extends Node

# Constants

# Signals
const ENEMY_KILLED = "enemy_killed"
const TOWER_PLACEMENT_CANCELLED = "tower_placement_cancelled"
const TOWER_PLACEMENT_CONFIRMED = "tower_placement_confirmed"


# Groups
const ENEMIES = "enemies"
const TOWERS = "towers"

# Layers
enum CollisionLayers {
	ALL,
	TOWERS,
	ENEMIES,
	PATH
}
