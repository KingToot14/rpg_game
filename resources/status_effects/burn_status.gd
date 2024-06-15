class_name BurnStatus
extends StatusEffect

# --- Variables --- #

#yg uk niuytds nuras nuts
# --- Functions --- #
func _init(init_entity: Entity = null, curr_stacks: int = 1) -> void:
	super(init_entity, curr_stacks)
	
	name = "Burn"
	key = &'burn'
