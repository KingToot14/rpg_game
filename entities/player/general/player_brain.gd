class_name PlayerBrain
extends EntityBrain

# --- Variables --- #


# --- Functions --- #
func _on_entity_selected(entity: Entity) -> void:
	# check if it is currently this player's turn
	if not parent.turn.taking_turn:
		return
	
	# make sure an action has been selected first
	if not action:
		return
	
	# make sure the target is actually targetable
	if not action.can_target(entity):
		return
	
	selected_target = entity
	
	parent.animator.play_action_anim(action.animation_name)
