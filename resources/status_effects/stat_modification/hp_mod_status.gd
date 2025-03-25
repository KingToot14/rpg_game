class_name HpModStatus
extends StatusEffect

# --- Variables --- #


# --- Functions --- #
func setup_signals() -> void:
	entity.turn_ended.connect(_root_turn_ended)
	
	entity.getting_stat.connect(_on_get_stat)

func set_status_info() -> void:
	max_stack = 100
	min_stack = -100
	
	decrement_value = 5
	
	additive = false
	
	key = &'hp_mod'
	if stacks > 0:
		name = "HP Buff"
		description = "Maximum health is increased temporarily"
	else:
		name = "HP Debuff"
		description = "Maximum health is decreased temporarily"

func _on_get_stat(stat: Globals.Stat, params := {}) -> void:
	if stat == Globals.Stat.HEALTH:
		params[&'stat'] *= 1.0 + (stacks / 100.0)
