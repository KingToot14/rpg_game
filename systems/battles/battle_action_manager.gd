class_name BattleActionManager
extends Node2D

# --- Signals --- #
signal action_performed()

signal action_changed(state: String)

# --- Variables --- #
var curr_state: ActionState
var menu_selection

# --- Functions --- #
func _ready():
	set_state('blank')

func set_state(state: String) -> void:
	if not has_node(state + "_state"):
		return
	
	curr_state = get_node(state + '_state') as ActionState
	curr_state.state_entered()
	curr_state.highlight_targets()
	
	# Reset selection
	menu_selection = null
	
	action_changed.emit(state)

func set_item(item: Resource):
	menu_selection = item

func perform_action() -> void:
	action_performed.emit()
	set_state('blank')

func entity_selected(entity: Entity) -> void:
	curr_state.entity_selected(entity)
