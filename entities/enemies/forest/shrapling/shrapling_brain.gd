class_name ShraplingBrain
extends EntityBrain

# --- Variables --- #


# --- Functions --- #
func _on_turn_started(_params := {}) -> void:
	action = parent.actions.get_random() as Attack
	
	if action.animation_name == &'acorn_spit':
		# repeat a few times
		Globals.turn_fsm.add_busy()
		
		for i in range(randi_range(2, 3)):
			await perform_action()
		
		parent.turn.end_turn()
		Globals.turn_fsm.remove_busy()
