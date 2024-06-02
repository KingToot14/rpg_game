class_name ActionFSM
extends Node2D

# --- Signals --- #
signal action_started()
signal action_performed()

signal action_changed(state: String)

# --- Variables --- #
var curr_state: ActionState

# --- Functions --- #
func _ready():
	Globals.action_fsm = self
	set_state('blank')

func set_state(state: String) -> void:
	if not has_node(state + "_state"):
		return
	
	curr_state = get_node(state + '_state') as ActionState
	curr_state.state_entered()
	curr_state.highlight_targets()
	
	action_changed.emit(state)

func start_action() -> void:
	action_started.emit()
	set_state('blank')

func perform_action() -> void:
	action_performed.emit()

func entity_selected(entity: Entity) -> void:
	curr_state.entity_selected(entity)
