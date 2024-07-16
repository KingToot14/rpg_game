class_name BleedStatus
extends StatusEffect

# --- Variables --- #
var dmg := 0.035
var heal_mod := 0.90

# --- Functions --- #
func set_status_info() -> void:
	max_stack = 100
	
	dmg = 0.020 + 0.015 * stage
	
	match stage:
		1:
			heal_mod = 0.90
		2:
			heal_mod = 0.75
		3:
			heal_mod = 0.50

func take_damage(damage: float) -> float:
	# ignore taking damage
	if damage > 0:
		return damage
	
	# reduce healing
	return damage * heal_mod

func turn_ended() -> float:
	entity.hp.take_damage(int(entity.stats.get_max_hp() * dmg), false)
	
	super()
	
	return DELAY_DURATION
