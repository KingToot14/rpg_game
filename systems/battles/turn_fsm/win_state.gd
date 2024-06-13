class_name WinState
extends TurnState

# --- Functions --- #
func state_entered() -> void:
	Globals.encounter_manager.handle_victory()
