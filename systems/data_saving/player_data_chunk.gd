class_name PlayerDataChunk
extends Resource

# --- Enums --- #
enum PlayerRole { NONE, MELEE, RANGED, HEALER, MAGIC }

# --- Variables --- #
var role: PlayerRole = PlayerRole.NONE

# - stats - #
var stats: EntityStats
var curr_hp: int = 210
var curr_special: float = 0
var curr_xp: int = 0
var curr_ap: int = 0

# - appearance - #
var body: String
var appearance: String

# --- Constants --- #
const APPEARANCE_PATH := "resources/appearances/"

# --- Functions --- #

# - HP - #
func store_hp(hp: int) -> void:
	curr_hp = clamp(hp, 0, stats.max_hp)

func store_special(special: float) -> void:
	curr_special = special

func heal(percent: float) -> void:
	store_hp(curr_hp + int(stats.max_hp * percent))

# - Appearance - #
func get_appearance_path() -> String:
	return APPEARANCE_PATH + appearance + ".tres"
