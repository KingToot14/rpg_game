class_name DefendingStatus
extends StatusEffect

# --- Variables --- #

# --- Functions --- #
func _init(init_entity: Entity = null, curr_stacks: int = 1) -> void:
	super(init_entity, curr_stacks)
	
	name = "Defend"
	key = &'defend'
	
	additive = false

func take_damage(dmg: float) -> float:
	return dmg / 2.0

func turn_ended() -> void:
	return

func turn_started() -> void:
	decrement_stacks()
