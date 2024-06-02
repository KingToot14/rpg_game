class_name GreenSlimeBrain
extends EntityBrain

# --- Variables --- #


# --- Functions --- #
func select_action() -> void:
	Globals.action_fsm.set_state('attack')

func select_attack() -> void:
	Globals.curr_item = parent.default_attack

func select_target() -> void:
	TargetingHelper.get_random_entity(&'player').select()
