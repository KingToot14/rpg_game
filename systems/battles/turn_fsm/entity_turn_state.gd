class_name EntityTurnState
extends TurnState

# --- Functions --- #
func state_entered() -> void:
	# Replenish turns
	var group = TargetingHelper.get_entities(group_name)
	for entity in group:
		if is_instance_valid(entity):
			entity.turn.replenish_actions()
	
	fsm.find_next_turn()

func entity_removed(entity: Entity) -> void:
	if entity.turn.taking_turn:
		fsm.find_next_turn()

#func action_performed() -> void:
	#if is_instance_valid(Globals.curr_entity):
		#Globals.curr_entity.turn.end_turn()
	#fsm.find_next_turn()
