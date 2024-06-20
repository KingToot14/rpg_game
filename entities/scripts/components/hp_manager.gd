class_name HpManager
extends Node

# --- Signals --- #
signal lost_health(dmg: int)
signal died()

# --- Variables --- #
var curr_hp: int
var alive := true

@export var load_max_hp: bool = false

# --- References --- #
var parent: Entity

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity
	
	get_tree().process_frame.connect(load_hp, CONNECT_ONE_SHOT)

func load_hp() -> void:
	if load_max_hp:
		curr_hp = DataManager.players[parent.spawn_index].curr_hp
	else:
		curr_hp = parent.stats.get_max_hp()

func take_damage(dmg: int, from_entity: bool = true) -> void:
	if from_entity:
		for effect in parent.status_effects.get_effects():
			dmg = effect.take_damage(dmg)
		
		parent.status_effects.remove_effects()
	
	curr_hp = max(curr_hp - dmg, 0)
	
	if curr_hp <= 0:
		alive = false
	
	lost_health.emit(dmg)

func get_hp_percent() -> float:
	return curr_hp / parent.stats.get_max_hp()

func do_death() -> void:
	died.emit()
	queue_free()

func store_hp() -> void:
	DataManager.players[parent.spawn_index].store_hp(curr_hp)
