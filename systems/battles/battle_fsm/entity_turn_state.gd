class_name EntityTurnState
extends BattleState

# --- Variables --- #
var group: Array[Entity]
var next_state: String

var curr_entity: Entity

# --- Functions --- #
func state_entered() -> void:
	# Replenish turns
	for entity in group:
		if is_instance_valid(entity):
			entity.replenish_actions()
	
	find_next_turn()

func entity_removed(entity: Entity) -> void:
	if entity == curr_entity:
		find_next_turn()

func action_performed() -> void:
	if is_instance_valid(curr_entity):
		curr_entity.decrement_action()
	find_next_turn()

# - Helper Functions - #
func find_next_turn() -> void:
	curr_entity = get_next_entity()
	
	if curr_entity:
		print("Turn: ", curr_entity.name)
	
	if not curr_entity:
		fsm.set_state(next_state)

func get_next_entity() -> Entity:
	var i = 0
	var group_size = len(group)
	
	if group_size <= 0:
		return null
	
	var entity: Entity = null
	while i < group_size:
		entity = group[i]
		if is_instance_valid(entity) and entity.can_act():
			return entity
		
		i += 1
	
	return null
