class_name GreenSlimeBrain
extends EntityBrain

# --- Functions --- #
func perform_turn() -> void:
	# always attack
	Globals.action_fsm.set_state('attack')
	
	# select random attack + target
	Globals.curr_item = parent.actions.attack_pool.pick_random()
	TargetingHelper.get_random_entity(&'player').targeting.select()
