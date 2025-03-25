class_name BurnStatus
extends StatusEffect

# --- Variables --- #
var dmg: float = 0.035
var dmg_mod := 0.90

#yg uk niuytds nuras nuts
# --- Functions --- #
func setup_signals() -> void:
	entity.turn_ended.connect(_root_turn_ended)
	
	entity.turn_ended.connect(_on_turn_ended)
	entity.took_damage.connect(_on_take_damage)

func set_status_info() -> void:
	max_stack = 100
	
	icon_pos = Vector2(3, 0)
	
	key = &'burn'
	
	dmg = 0.020 + 0.015 * stage
	
	match stage:
		1:
			name = "Overheating"
			description = (
				"Receieve minor fire damage each turn\n" +
				"Receives less damage from nature and ice damage\n" +
				"Removed by water damage"
			)
			dmg_mod = 0.90
		2:
			name = "Burning"
			description = (
				"Receieve low fire damage each turn\n" +
				"Receives less damage from nature and ice damage\n" +
				"Removed by water damage"
			)
			dmg_mod = 0.70
		3:
			name = "Scoarching"
			description = (
				"Receieve moderate fire damage each turn\n" +
				"Receives less damage from nature and ice damage\n" +
				"Removed by water damage"
			)
			dmg_mod = 0.50

func _on_turn_ended(_params: Dictionary) -> void:
	entity.hp.take_damage({
		&'damage': roundi(entity.stats.get_max_hp() * dmg),
		&'element': Attack.Element.FIRE,
		&'element_percent': 1.0,
		&'source': &'status'
	})
	
	decrement_stacks()

func _on_take_damage(dmg_chunk: Dictionary) -> void:
	# remove if water damage taken
	if dmg_chunk[&'element'] == Attack.Element.WATER:
		remove_status()
		return
	
	# nature and ice deal reduced damage
	var mod := 1.0
	var percent := dmg_chunk.get(&'element_percent', 0.0) as float
	
	if dmg_chunk.get(&'element', Attack.Element.NONE) & (Attack.Element.NATURE | Attack.Element.ICE):
		mod = dmg_mod
	
	dmg_chunk[&'damage'] *= (1.0 - percent) + (percent * mod)
