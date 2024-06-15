class_name EmpowerStatus
extends StatusEffect

# --- Variables --- #


# --- Functions --- #
func _init(curr_entity: Entity = null, curr_stacks: int = 5) -> void:
	super(curr_entity, curr_stacks)
	
	name = "Empower"
	key = &'empower'
	
	max_stack = 100
	decrement_value = 5
	additive = false

func get_p_attack(attack: float) -> float:
	return attack * (1.0 + (stacks / 100.0))
