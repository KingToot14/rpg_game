class_name HasteStatus
extends StatusEffect

# --- Variables --- #


# --- Functions --- #
func _init(init_entity: Entity = null, curr_stacks: int = 1) -> void:
	super(init_entity, curr_stacks)
	
	name = "Haste"
	key = &'haste'

func turn_ended() -> void:
	entity.action_count += 1
	
	super()
