class_name GreenSlimeBrain
extends EntityBrain

# --- Functions --- #
func _on_turn_started(_params := {}) -> void:
	# select random attack + target
	action = parent.actions.get_random()
	selected_target = TargetingHelper.get_random_entity(&'player')
	
	perform_action()
