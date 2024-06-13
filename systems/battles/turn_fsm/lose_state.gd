class_name LoseState
extends TurnState

# --- Functions --- #
func state_entered() -> void:
	Globals.encounter_manager.handle_loss()
