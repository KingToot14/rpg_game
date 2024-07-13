class_name AreaDataChunk
extends Resource

# --- Variables --- #
var opened_chests: Array[StringName] = []
var defeated_encounters: Array[StringName] = []
var solved_puzzles: Array[StringName] = []
var dialogue_states = {}
var flags = {}

# --- Functions --- #
func _init(load_info = null) -> void:
	if not load_info:
		load_info = {}
	
	var chests = load_info.get('chests', [])
	for chest in chests:
		opened_chests.append(chest)
	
	var encounters = load_info.get('encounters', [])
	for encounter in encounters:
		defeated_encounters.append(encounter)
	
	var puzzles = load_info.get('puzzles', [])
	for puzzle in puzzles:
		solved_puzzles.append(puzzle)
	
	dialogue_states = load_info.get('dialogue', {})
	flags = load_info.get('flags', {})

func get_save_data() -> Dictionary:
	return {
		'chests': 		opened_chests,
		'encounters': 	defeated_encounters,
		'puzzles': 		solved_puzzles,
		'dialogue': 	dialogue_states,
		'flags': 		flags
	}

# - Chests - #
func open_chest(key: StringName) -> void:
	opened_chests.append(key)

func is_open(key: StringName) -> bool:
	return key in opened_chests

# - Encounters - #
func add_victory(key: StringName) -> void:
	defeated_encounters.append(key)

func is_defeated(key: StringName) -> bool:
	return key in defeated_encounters

# - Puzzles - #
func solve_puzzle(key: StringName) -> void:
	solved_puzzles.append(key)

func is_solved(key: StringName) -> bool:
	return key in solved_puzzles

# - Dialogue - #
func get_dialogue_state(key: StringName) -> String:
	return dialogue_states.get(key, "")

func set_dialogue_state(key: StringName, state: String) -> void:
	dialogue_states[key] = state
