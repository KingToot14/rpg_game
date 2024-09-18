class_name GreenSlimeBrain
extends EntityBrain

# --- Functions --- #
func _on_turn_started() -> void:
	# select random attack + target
	action = parent.actions.attack_pool.pick_random()
	selected_target = TargetingHelper.get_random_entity(&'player')
	
	perform_action(action)
