class_name DefendingStatus
extends StatusEffect

# --- Variables --- #

# --- Functions --- #
func set_status_info() -> void:
	name = "Defend"
	key = &'defend'
	
	additive = false

func take_damage(dmg: float) -> float:
	return dmg / 2.0

func turn_ended() -> void:
	return

func turn_started() -> void:
	decrement_stacks()
