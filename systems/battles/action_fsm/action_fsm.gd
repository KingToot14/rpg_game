class_name ActionFSM
extends Node2D

# --- Signals --- #
signal action_started()
signal action_performed()

signal action_changed(state: String)
signal targeting_changed()

# --- Variables --- #
var curr_state: ActionState
var targeting: bool = true

# --- Functions --- #
func set_state(state: String) -> void:
	if not has_node(state + "_state"):
		return
	
	if curr_state and (state + "_state") == curr_state.name:
		set_state('blank')
		return
	
	TargetingHelper.disable_highlights()
	targeting = false
	targeting_changed.emit()
	
	curr_state = get_node(state + '_state') as ActionState
	curr_state.state_entered()
	curr_state.highlight_targets()
	
	action_changed.emit(state)

func item_set() -> void:
	if Globals.curr_item and curr_state:
		targeting = true
		targeting_changed.emit()

func start_action() -> void:
	set_state('blank')
	action_started.emit()

func perform_action() -> void:
	action_performed.emit()

func entity_selected(entity: Entity) -> void:
	curr_state.entity_selected(entity)
