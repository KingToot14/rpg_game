class_name FleeTactic
extends Tactic

# --- Variables --- #


# --- Functions --- #
func perform_action(_target: Entity) -> void:
	Globals.encounter_manager.load_overworld()
