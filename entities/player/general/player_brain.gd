class_name PlayerBrain
extends EntityBrain

# --- Variables --- #
var targeting_all := false

# --- Functions --- #
func _on_turn_started(_params := {}) -> void:
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
		action.highlight_targets(parent)

func _on_entity_selected(entity: Entity) -> void:
	# check if it is currently this player's turn
	if not parent.turn.taking_turn:
		return
	
	# make sure an action has been selected first
	if not action:
		return
	
	targeting_all = not entity
	
	# make sure the target is actually targetable
	if not targeting_all and not action.can_target(entity):
		return
	
	selected_target = entity
	
	# disable highlighting
	TargetingHelper.disable_highlights()
	
	# show timing
	if action is Attack:
		setup_timing()
	
	# start attack
	perform_action()
	Globals.ui_manager.set_action_state(BattleUiManager.ActionState.Hidden)
	action.perform_action(selected_target)

func setup_timing() -> void:
	var timing_mode = DataManager.options.timing_mode
	Globals.timing_mods = []
	
	if timing_mode == &'disabled':
		return
	
	if timing_mode == &'timing_only' or action.timing_type == Attack.TimingType.TIMED_INPUT:
		Globals.ui_manager.show_timing(&'single_hit', parent.animator.get_timed_inputs(action.animation_name))
	elif action.timing_type == Attack.TimingType.MASH:
		pass
