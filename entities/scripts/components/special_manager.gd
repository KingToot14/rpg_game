class_name SpecialManager
extends Node

# --- Signals --- #
signal special_changed()

# --- Variables --- #
var curr_special: float

@export var load_special := false
@export var modifier := 0.20

# --- References --- #
var parent: Entity

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity
	
	if load_special:
		curr_special = DataManager.players[parent.spawn_index].curr_special
	else:
		curr_special = 54

func _on_health_changed(delta: int) -> void:
	if delta >= 0:
		return
	
	curr_special += (-delta / parent.stats.get_max_hp()) * modifier

func store_special() -> void:
	DataManager.players[parent.spawn_index].store_special(curr_special)
