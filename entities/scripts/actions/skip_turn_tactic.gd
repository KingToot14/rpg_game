class_name SkipTurnTactic
extends Tactic

# --- Variables --- #


# --- Functions --- #
func perform_action(target: Entity) -> void:
	Globals.turn_fsm.set_entity(target)
