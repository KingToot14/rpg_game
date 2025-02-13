class_name BleedStatus
extends StatusEffect

# --- Variables --- #
var dmg := 0.035
var heal_mod := 0.90

# --- Functions --- #
func setup_signals() -> void:
	entity.turn_ended.connect(_on_turn_ended)
	entity.took_damage.connect(_on_take_damage)

func set_status_info() -> void:
	max_stack = 100
	
	match stage:
		1:
			heal_mod = 0.90
			dmg = 0.035
		2:
			heal_mod = 0.75
			dmg = 0.050
		3:
			heal_mod = 0.50
			dmg = 0.065

func _on_turn_ended(_params: Dictionary) -> void:
	entity.hp.take_damage({
		&'damage': roundi(entity.stats.get_max_hp() * dmg),
		&'element': Attack.Element.NONE,
		&'element_percent': 1.0,
		&'source': &'status'
	})
	
	decrement_stacks()

func _on_take_damage(params: Dictionary) -> void:
	# ignore taking damage
	if params.get(&'damage', 0) > 0:
		return
	
	# reduce healing
	params[&'damage'] *= heal_mod
