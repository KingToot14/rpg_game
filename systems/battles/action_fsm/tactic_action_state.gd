class_name TacticActionState
extends ActionState

# --- Functions --- #
func entity_selected(entity: Entity) -> void:
	var tactic = Globals.curr_item
	
	if not (tactic and tactic is Tactic):
		print("No tactic selected")
		return
	tactic = tactic as Tactic
	
	if not entity.targeting.targetable:
		return
	
	Globals.curr_target = entity
	
	# Disable highlighting
	TargetingHelper.disable_highlights()
	
	perform_action()

func perform_action() -> void:
	Globals.curr_item.do_tactic()
