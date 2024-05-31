class_name AttackActionState
extends ActionState

# --- Functions --- # 
func entity_selected(entity: Entity) -> void:
	var attack = fsm.menu_selection
	if not (attack and attack is Attack):
		print("No attack selected")
		return
	attack = attack as Attack
	
	# Check if valid target
	if entity.is_player and attack.side == Attack.TargetSide.ENEMY:
		return
	if not entity.is_player and attack.side == Attack.TargetSide.PLAYER:
		return
	
	target = entity
	
	perform_action()

func perform_action() -> void:
	var attack = fsm.menu_selection as Attack
	
	var dmg = round(attack.calculate_damage(root.curr_entity, target))
	
	target.take_damage(dmg)
	
	fsm.perform_action()
