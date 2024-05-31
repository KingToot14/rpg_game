class_name GreenSlimeBrain
extends EntityBrain

# --- Variables --- #


# --- Functions --- #
func select_action() -> void:
	parent.root.action_fsm.set_state('attack')

func select_attack() -> void:
	parent.root.action_fsm.set_item(parent.default_attack)

func select_target() -> void:
	parent.root.get_random_player().select()
