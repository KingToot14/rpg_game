class_name DefenseActionState
extends ActionState

# --- Functions --- #
func state_entered() -> void:
	Globals.ui_manager.load_attacks()

func entity_selected(entity: Entity) -> void:
	var defense = Globals.curr_item
	
	if not (defense and defense is Defense):
		print("No defense selected")
		return
	defense = defense as Defense
	
	if entity != Globals.curr_entity:
		return
	
	# Disable highlighting
	TargetingHelper.disable_highlights()
	
	perform_action()

func perform_action() -> void:
	if Globals.attack_manager.setup_defense():
		fsm.start_action()
