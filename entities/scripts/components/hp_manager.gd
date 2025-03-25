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
	
	if dmg_chunk.get(&'move_hit', true):
		parent.took_damage.emit(dmg_chunk)
		
		# calculate crit
		var crit_rate = dmg_chunk.get(&'crit_rate', 0.0)
		dmg_chunk[&'crits_hit'] = floori(crit_rate)
		
		# every 100% guarantees a crit
		var crit_boost = floori(crit_rate) * 0.50
		crit_rate -= floori(crit_rate)
		
		if randf() <= crit_rate:
			crit_boost += 0.5
			dmg_chunk[&'crits_hit'] += 1
		
		# apply boost
		dmg_chunk[&'damage'] *= 1.0 + crit_boost
		
		# take damage
		curr_hp = max(curr_hp - roundi(dmg_chunk[&'damage']), 0)
		
		if curr_hp <= 0:
			alive = false
	
	lost_health.emit(dmg_chunk)

func do_death() -> void:
	died.emit()

func get_hp_percent() -> float:
	return curr_hp / parent.stats.get_max_hp()

func store_hp() -> void:
	DataManager.players[parent.spawn_index].store_hp(curr_hp)
