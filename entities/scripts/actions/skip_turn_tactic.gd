class_name SkipTurnTactic
extends Tactic

# --- Variables --- #


# --- Functions --- #
func perform_action(target: Entity) -> void:
	target.turn.end_turn()
