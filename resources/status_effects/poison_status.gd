class_name PoisonStatus
extends StatusEffect

# --- Variables --- #
var dmg := 0.035
var turns := 1

var spread_chance := 0.35
var spread_stacks := 2

# --- Functions --- #
func set_status_info() -> void:
	max_stack = 100
	
	if stage != 3:
		turns = 1

func turn_ended() -> float:
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
	
	# deal damage		TODO: Change to damage chunk
	entity.hp.take_damage(int(entity.stats.get_max_hp() * dmg * turns), false)
	
	super()
	
	return DELAY_DURATION
