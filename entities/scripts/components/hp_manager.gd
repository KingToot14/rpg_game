class_name HpManager
extends Node

# --- Signals --- #
signal lost_health(dmg_chunk: Dictionary)
signal died()

# --- Variables --- #
var curr_hp := 10
var alive := true

@export var load_max_hp: bool = false

# --- References --- #
var parent: Entity

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity
	
	parent.entity_setup.connect(load_hp)

func load_hp() -> void:
	if load_max_hp:
		curr_hp = DataManager.players[parent.spawn_index].curr_hp
	else:
		curr_hp = int(parent.stats.get_max_hp())

func take_damage(dmg_chunk: Dictionary) -> void:
	if not alive:
		return
	
	parent.took_damage.emit(dmg_chunk)
	
	# calculate damage
	var dmg = dmg_chunk.get(&'damage', 0)
	dmg *= dmg_chunk.get(&'element_percent') * (1.0 - dmg_chunk.get(&'element_mod', 1.0))
	
	curr_hp = max(curr_hp - roundi(dmg), 0)
	
	if curr_hp <= 0:
		alive = false
	
	lost_health.emit(dmg_chunk)

func do_death() -> void:
	died.emit()

func get_hp_percent() -> float:
	return curr_hp / parent.stats.get_max_hp()

func store_hp() -> void:
	DataManager.players[parent.spawn_index].store_hp(curr_hp)
