class_name EmpowerStatus
extends StatusEffect

# --- Variables --- #


# --- Functions --- #
func set_status_info() -> void:
	max_stack = 100
	decrement_value = 5
	additive = false

func get_p_attack(attack: float) -> float:
	return attack * (1.0 + (stacks / 100.0))
