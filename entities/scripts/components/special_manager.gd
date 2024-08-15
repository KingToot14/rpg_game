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
	
	parent.entity_setup.connect(load_spec)

func load_spec():
	if load_special:
		curr_special = DataManager.players[parent.spawn_index].curr_special
	else:
		curr_special = 54

func _on_lost_health(dmg_chunk: DamageChunk) -> void:
	if dmg_chunk.damage < 0:
		return
	
	curr_special += (dmg_chunk.damage / parent.stats.get_max_hp()) * modifier

func store_special() -> void:
	DataManager.players[parent.spawn_index].store_special(curr_special)
