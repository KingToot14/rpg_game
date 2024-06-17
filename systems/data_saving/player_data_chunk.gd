class_name PlayerDataChunk
extends Resource

# --- Enums --- #
enum PlayerRole { NONE, MELEE, RANGED, HEALER, MAGIC }

# --- Variables --- #
var role: PlayerRole = PlayerRole.NONE

var stats: EntityStats
var curr_hp: int = 210
var curr_special: float = 0
var curr_xp: int = 0
var curr_ap: int = 0

# --- Functions --- #

# - HP - #
func store_hp(hp) -> void:
	curr_hp = clamp(hp, 0, stats.max_hp)

func heal(percent: float) -> void:
	store_hp(curr_hp + stats.max_hp * percent)
