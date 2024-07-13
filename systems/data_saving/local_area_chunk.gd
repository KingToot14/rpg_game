class_name LocalAreaChunk
extends Resource

# --- Variables --- #
var area_path: String = ""
var name: String = ""
var player_position: Vector2 = Vector2(136, 142)

var defeated_encounters: Array[StringName]

# --- Functions --- #
func _init(load_info = null) -> void:
	if not load_info:
		load_info = {}
	
	area_path = load_info.get('area_path', "")
	
	if not area_path.is_empty():
		Globals.overworld_area = area_path
	
	name = load_info.get('name', "")
	player_position = load_info.get('player_pos', Vector2(136, 142))
	
	var encounters = load_info.get('encounters', [])
	
	for encounter in encounters:
		defeated_encounters.append(encounter)

func get_save_data() -> Dictionary:
	return {
		'area_path': 	area_path,
		'name': 		name,
		'player_pos': 	player_position,
		'encounters': 	defeated_encounters
	}

# - Encounters - #
func add_victory(key: StringName) -> void:
	defeated_encounters.append(key)

func is_defeated(key: StringName) -> bool:
	return key in defeated_encounters

# - Path - #
func set_area_path(path: String) -> void:
	area_path = path
	name = path.split("/")[-1]
	name = name.substr(0, name.length() - 5)
