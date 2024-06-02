class_name EntityTurnState
extends TurnState

# --- Variables --- #
var group_name: StringName
var next_state: String

# --- Functions --- #
func state_entered() -> void:
	# Replenish turns
	var group = TargetingHelper.get_entities(group_name)
	for entity in group:
		if is_instance_valid(entity):
			entity.replenish_actions()
	
	find_next_turn()

func entity_removed(entity: Entity) -> void:
	if entity == Globals.curr_entity:
		find_next_turn()

func action_performed() -> void:
	if is_instance_valid(Globals.curr_entity):
		Globals.curr_entity.decrement_action()
	find_next_turn()

# - Helper Functions - #
func find_next_turn() -> void:
	Globals.curr_entity = get_next_entity()
	
	if Globals.curr_entity:
		fsm.start_turn()
		Globals.curr_entity.take_turn()
	else:
		fsm.set_state(next_state)

func get_next_entity() -> Entity:
	var i = 0
	var group = TargetingHelper.get_entities(group_name)
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
