class_name AttackActionState
extends ActionState

# --- Functions --- # 
func entity_selected(entity: Entity) -> void:
	var attack = Globals.curr_item
	if not (attack and attack is Attack):
		print("No attack selected")
		return
	attack = attack as Attack
	
	# Check if valid target
	if entity.is_player and attack.side == Attack.TargetSide.ENEMY:
		return
	if not entity.is_player and attack.side == Attack.TargetSide.PLAYER:
		return
	
	Globals.curr_targets[0] = entity
	
	perform_action()

func perform_action() -> void:
	fsm.start_action()
	Globals.attack_manager.setup_attack()
