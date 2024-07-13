class_name PlayerDataChunk
extends Resource

# --- Enums --- #
enum PlayerRole { NONE, MELEE, RANGED, HEALER, MAGIC }

# --- Variables --- #
var role: PlayerRole = PlayerRole.NONE

# - stats - #
var level := 1
var stats: EntityStats
var curr_hp := 210
var curr_special := 0.0
var curr_xp := 0
var xp_to_next := 50

# - appearance - #
var body: String
var appearance := "pastel_blue"

# --- Constants --- #
const APPEARANCE_PATH := "resources/appearances/"

const BASE_LEVEL_UP_XP := 50
const LEVEL_UP_MOD := 1.10

# --- Functions --- #
func _init(load_info = null) -> void:
	if not load_info:
		return
	
	# TODO: Implement Save System

func get_save_data() -> Dictionary:
	return {
		'role': 		role,
		'level': 		level,
		'hp': 			curr_hp,
		'special':	 	curr_special,
		'xp':			curr_xp,
		'body':			body,
		'appearance':	appearance
	}

func create_new(new_role: PlayerRole) -> void:
	# basic info
	role = new_role
	level = 1
	
	# load stats
	match role:
		PlayerRole.MELEE:
			stats = load("res://entities/player/melee/stats.tres") as EntityStats
		PlayerRole.RANGED:
			stats = load("res://entities/player/ranged/stats.tres") as EntityStats
		PlayerRole.HEALER:
			stats = load("res://entities/player/healer/stats.tres") as EntityStats
		PlayerRole.MAGIC:
			stats = load("res://entities/player/magic/stats.tres") as EntityStats
	
	# load hp
	heal_to_full()
	curr_special = 0.0
	
	# load xp
	curr_xp = 0
	xp_to_next = get_xp_to_level()

func set_appearance(value: String) -> void:
	appearance = value

# - HP - #
func store_hp(hp: int) -> void:
	curr_hp = clamp(hp, 0, stats.get_max_hp())

func store_special(special: float) -> void:
	curr_special = special

func heal_to_full() -> void:
	curr_hp = stats.get_max_hp(level)

# - Appearance - #
func get_appearance_path() -> String:
	return APPEARANCE_PATH + appearance + ".tres"

# - XP - #
func get_xp_to_level(to_level := -1) -> int:
	if to_level < 0:
		to_level = level
	elif to_level == 0:
		return 0
	
	return BASE_LEVEL_UP_XP * LEVEL_UP_MOD ** (to_level - 1)

func get_remaining_xp() -> int:
	return xp_to_next - curr_xp

func set_xp(xp: int) -> bool:
	curr_xp = xp
	
	if curr_xp >= xp_to_next:
		level_up()
		return true
	
	return false

func add_xp(xp: int) -> bool:
	return set_xp(curr_xp + xp)

func level_up() -> void:
	level += 1
	
	xp_to_next += get_xp_to_level()
	heal_to_full()
	
	if curr_xp >= xp_to_next:
		level_up()
