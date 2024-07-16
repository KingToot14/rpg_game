class_name BurnStatus
extends StatusEffect

# --- Variables --- #
var dmg: float = 0.035

#yg uk niuytds nuras nuts
# --- Functions --- #
func set_status_info() -> void:
	max_stack = 100
	
	dmg = 0.020 + 0.015 * stage

func turn_ended() -> float:
	entity.hp.take_damage(int(entity.stats.get_max_hp() * dmg), false)
	
	super()
	
	return DELAY_DURATION
