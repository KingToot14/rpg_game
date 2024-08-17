class_name DialogueControlState
extends PlayerControlState

# --- Functions --- #
func handle_process(_delta: float) -> void:
	if not Globals.curr_dialogue:
		player.set_state('moving')
	if player.direction != Vector2.ZERO:
		Globals.curr_dialogue.close()
		player.set_state('moving')
