class_name TrainingDummyBrain
extends EntityBrain

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	super()
	
	print(parent)

func _on_turn_started(_params := {}) -> void:
	print("What?")
	
	# add delay to not break system
	await get_tree().create_timer(action_delay).timeout
	
	# simply skip turn
	parent.turn.actions_remaining = 0
	
	#parent.turn.end_turn()
	parent.get_node("managers/animator").end_turn()
