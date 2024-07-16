class_name DefendingStatus
extends StatusEffect

# --- Variables --- #

# --- Functions --- #
func set_status_info() -> void:
	additive = false

func take_damage(dmg: float) -> float:
	return dmg / 2.0

func turn_ended() -> float:
	return 0.0

func turn_started() -> float:
	decrement_stacks()
	
	return 0.0
