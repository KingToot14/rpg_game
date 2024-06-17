class_name FleeTactic
extends Tactic

# --- Variables --- #


# --- Functions --- #
func do_tactic() -> void:
	Globals.encounter_manager.load_overworld()

func highlight_targets() -> void:
	Globals.curr_entity.set_targetable(true)
