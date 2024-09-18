class_name PlayerBrain
extends EntityBrain

# --- Variables --- #


# --- Functions --- #
func _on_turn_started() -> void:
	Globals.ui_manager.load_player_action(parent)
	Globals.ui_manager.set_action_state(BattleUiManager.ActionState.ActionBar)

func _on_action_selected(new_action: Resource) -> void:
	if not parent.turn.taking_turn:
		return
	
	# show the cancel button/return to the action bar
	if new_action:
		Globals.ui_manager.set_action_state(BattleUiManager.ActionState.CancelButton)
	else:
		Globals.ui_manager.set_action_state(BattleUiManager.ActionState.ActionBar)
	
	action = new_action
	
	# show targeting highlights
	if action:
		action.highlight_targets()

func _on_entity_selected(entity: Entity) -> void:
	# check if it is currently this player's turn
	if not parent.turn.taking_turn:
		return
	
	# make sure an action has been selected first
	if not action:
		return
	
	# make sure the target is actually targetable
	if not action.can_target(entity):
		return
	
	selected_target = entity
	
	# disable highlighting
	for e in get_tree().get_nodes_in_group(&'entity'):
		e.targeting.set_targetable(false)
	
	# start attack
	perform_action(action)
	Globals.ui_manager.set_action_state(BattleUiManager.ActionState.Hidden)
	action.perform_action(selected_target)
