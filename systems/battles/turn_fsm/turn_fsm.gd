class_name TurnFSM
extends Node2D

# --- Signals --- #
signal state_changed(state: String)

# --- Variables --- #
var curr_state: TurnState

# --- Functions --- #
func set_state(state: String) -> void:
	if not has_node(state + "_state"):
		return
	
	curr_state = get_node(state + "_state") as TurnState
	curr_state.state_entered()
	
	state_changed.emit(state)

func entity_removed(entity: Entity) -> void:
	curr_state.entity_removed(entity)

func action_performed() -> void:
	curr_state.action_performed()
