class_name Encounter
extends Resource

# --- Variables --- #
@export var encounter_key: StringName
@export var respawn: bool = true

@export var waves: Array[Wave]

# --- Functions --- #
func handle_victory() -> void:
	if respawn:
		DataManager.local_area.add_victory(encounter_key)
	else:
		DataManager.add_victory(encounter_key)
