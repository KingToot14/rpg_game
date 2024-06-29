class_name BlazingMageflowerBrain
extends EntityBrain

# --- Functions --- #
func select_action() -> void:
	Globals.action_fsm.set_state('attack')

func select_attack() -> void:
	Globals.curr_item = parent.actions.attack_pool.pick_random()

func select_target() -> void:
	TargetingHelper.get_random_entity(&'player').targeting.select()
