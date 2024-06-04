class_name TurnFSM
extends Node2D

# --- Signals --- #
signal turn_started()

signal state_changed(state: String)

# --- Variables --- #
var curr_state: TurnState

@export var turn_switch_delay: float = 0.0

# --- Functions --- #
func set_state(state: String) -> void:
	if not has_node(state + "_state"):
		return
	
	await get_tree().create_timer(turn_switch_delay).timeout
	
	curr_state = get_node(state + "_state") as TurnState
	curr_state.state_entered()
	
	state_changed.emit(state)

func start_turn() -> void:
	turn_started.emit()

func entity_removed(entity: Entity) -> void:
	curr_state.entity_removed(entity)

func action_performed() -> void:
	curr_state.action_performed()
