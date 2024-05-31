class_name BattleFsm
extends Node2D

# --- Signals --- #
signal state_changed(state: String)

# --- Variables --- #
var curr_state: BattleState

# --- Functions --- #
func set_state(state: String) -> void:
	if curr_state:
		curr_state.state_exited()
	
	if not has_node(state + "_state"):
		return
	
	curr_state = get_node(state + "_state") as BattleState
	curr_state.state_entered()
	
	state_changed.emit(state)

func entity_removed(entity: Entity) -> void:
	curr_state.entity_removed(entity)

func action_performed() -> void:
	curr_state.action_performed()
