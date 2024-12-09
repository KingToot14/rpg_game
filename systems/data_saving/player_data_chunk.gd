class_name PlayerDataChunk
extends Resource

# --- Enums --- #
enum PlayerRole { NONE, MELEE, RANGED, MONK, MAGIC }

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
var name: String = "Name"
var description: String = "Description"
var body: String
var appearance := "pastel_blue"

# - equipment - #
var weapon: Equipment
var armor: Equipment
var special: Equipment

# --- Constants --- #
const APPEARANCE_PATH := "resources/appearances/"

const BASE_LEVEL_UP_XP := 50
const LEVEL_UP_MOD := 1.10

# --- Functions --- #
func _init(load_info = null) -> void:
	if not load_info:
		load_info = {}
	
	if 'role' in load_info:
		# player role is none
		if not create_new(load_info['role']):
			return
	else:
		return
	
	level = max(load_info.get('level', 1), 1)
	curr_hp = max(load_info.get('hp', stats.get_max_hp(level)), 0)
	curr_special = clamp(load_info.get('special', 0.0), 0.0, 1.0)
	
	# xp
	xp_to_next = get_cumulative_xp()
	curr_xp = clamp(load_info.get('xp', 0), get_cumulative_xp(level - 1), xp_to_next)
	
	# appearance
	name = load_info.get('name', "Name")
	body = load_info.get('body', "")
	appearance = load_info.get('appearance', 'pastel_blue')

func get_save_data() -> Dictionary:
	return {
		'name':			name,
		'role': 		role,
		'level': 		level,
		'hp': 			curr_hp,
		'special':	 	curr_special,
		'xp':			curr_xp,
		'body':			body,
		'appearance':	appearance
	}

func create_new(new_role: PlayerRole) -> bool:
	# basic info
	role = new_role
	level = 1
	
	# load stats
	match role:
		PlayerRole.MELEE:
			# load stats
			stats = load("res://entities/player/melee/stats.tres") as EntityStats
			
			# load default equipment
			armor = load("res://entities/player/melee/armor/natures_tunic.tres") as Equipment
			weapon = load("res://entities/player/melee/weapons/oakris_blade.tres") as Equipment
			special = load("res://entities/player/melee/rages/primal_rage.tres") as Equipment
		PlayerRole.RANGED:
			# load stats
			stats = load("res://entities/player/ranger/stats.tres") as EntityStats
			
			# load default equipment
		PlayerRole.MONK:
			# load stats
			stats = load("res://entities/player/monk/stats.tres") as EntityStats
			
			# load default equipment
		PlayerRole.MAGIC:
			# load stats
			stats = load("res://entities/player/magic/stats.tres") as EntityStats
			
			# load default equipment
		_:
			return false
	
	# load hp
	heal_to_full()
	curr_special = 0.0
	
	# load xp
	curr_xp = 0
	xp_to_next = get_cumulative_xp()
	
	return true

func set_appearance(value: String) -> void:
	appearance = value

# - HP - #
func store_hp(hp: int) -> void:
	curr_hp = clamp(hp, 0, stats.get_max_hp())

func store_special(special: float) -> void:
	curr_special = special

func heal_to_full() -> void:
	if stats:
		curr_hp = stats.get_max_hp(level)

# - Appearance - #
func get_appearance_path() -> String:
	return APPEARANCE_PATH + appearance + ".tres"

#region XP
func get_xp_to_level(to_level := -1) -> int:
	if to_level < 0:
		to_level = level
	elif to_level == 0:
		return 0
	
	return roundi(BASE_LEVEL_UP_XP * LEVEL_UP_MOD ** (to_level - 1))

func get_cumulative_xp(to_level := -1) -> int:
	if to_level < 0:
		to_level = level
	elif to_level == 0:
		return 0
	
	var total = 0
	
	for i in range(1, to_level + 1):
		total += get_xp_to_level(i)
	
	return total

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
	
	xp_to_next = get_cumulative_xp()
	heal_to_full()
	
	if curr_xp >= xp_to_next:
		level_up()

#endregion

#region Stats
func get_max_hp() -> int:
	return stats.get_max_hp(level)

func get_p_attack() -> float:
	return stats.get_p_attack(level)

func get_m_attack() -> float:
	return stats.get_m_attack(level)

func get_p_defense() -> float:
	return stats.get_p_defense(level)

func get_m_defense() -> float:
	return stats.get_m_defense(level)

func get_accuracy() -> float:
	return stats.get_accuracy(level)

func get_evasion() -> float:
	return stats.get_evasion(level)

#endregion

#region Equipment
func set_equipment(key: StringName, value: Equipment) -> void:
	if value == null:
		return
	
	match key:
		&'armor':
			armor = value
		&'weapon':
			weapon = value
		&'special':
			special = value

#endregion
