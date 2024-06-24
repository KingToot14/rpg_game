class_name AttackActionState
extends ActionState

# --- Functions --- # 
func state_entered() -> void:
	Globals.ui_manager.load_attacks()

func entity_selected(entity: Entity) -> void:
	var attack = Globals.curr_item
	
	if not (attack and attack is Attack):
		print("No attack selected")
		return
	attack = attack as Attack
	
	# Check if valid target
	
	if Globals.curr_entity.is_player() and not entity.targeting.targetable:
		return
	
	Globals.curr_target = entity
	
	# Disable highlighting
	TargetingHelper.disable_highlights()
	
	perform_action()

func perform_action() -> void:
	if Globals.attack_manager.setup_attack():
		fsm.start_action()
