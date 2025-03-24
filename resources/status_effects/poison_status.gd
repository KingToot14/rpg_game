class_name PoisonStatus
extends StatusEffect

# --- Variables --- #
var dmg := 0.035
var turns := 1

var spread_chance := 0.35
var spread_stacks := 2

# --- Functions --- #
func setup_signals() -> void:
	entity.turn_ended.connect(_on_turn_ended)

func set_status_info() -> void:
	max_stack = 100
	
	icon_pos = Vector2(2, 1)
	
	match stage:
		1:
			name = "Poisoned"
			description = (
				"Receives minor nature damage each turn" 
			)
			turns = 1
		2:
			name = "Contagious"
			description = (
				"Receives minor nature damage each turn\n" +
				"Has a chance to spread to either side" 
			)
			turns = 1
		3:
			name = "Irradiated"
			description = (
				"Receives nature damage each turn\n" +
				"Damage increases each turn\n" +
				"Has a chance to spread to either side" 
			)
			pass

func _on_turn_ended(_params: Dictionary) -> void:
	# increase irradiated damage
	if stage == 3:
		turns += 1
	
	# spread to other entities
	if stage > 1:
		var entities = TargetingHelper.get_entities()
		
		for e in entities:
			var rand = randf()
			
			if rand < spread_chance:
				e.status_effects.add_effect(&'poison', randi_range(1, spread_stacks), stage)
	
	# deal damage
	entity.hp.take_damage({
		&'damage': roundi(entity.stats.get_max_hp() * dmg * turns),
		&'element': Attack.Element.NATURE,
		&'element_percent': 1.0,
		&'source': &'status'
	})
	
	decrement_stacks()
