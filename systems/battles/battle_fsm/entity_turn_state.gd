class_name EntityTurnState
extends BattleState

# --- Variables --- #
var group: Array[Entity]
var next_state: String

var curr_entity: Entity
var entity_index: int = 0

# --- Functions --- #
func state_entered() -> void:
	# Replenish turns
	for entity in group:
		entity.replenish_actions()
	
	entity_index = 0
	find_next_turn()

func action_performed() -> void:
	curr_entity.take_action()
	find_next_turn()

# - Helper Functions - #
func find_next_turn() -> void:
	curr_entity = get_next_entity()
	
	if not curr_entity:
		fsm.set_state(next_state)

func get_next_entity() -> Entity:
	var i = entity_index
	
	var entity: Entity = null
	while i != (entity_index - 1) % len(group):
		entity = group[i]
		if entity and entity.can_act():
			entity_index = i
			return entity
		
		i = (i + 1) % len(group)
	
	entity = group[entity_index]
	return entity if entity.can_act() else null
