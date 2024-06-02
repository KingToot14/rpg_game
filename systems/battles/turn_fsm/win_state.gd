class_name WinState
extends TurnState

# --- Functions --- #
func state_entered() -> void:
	print("Victory!")
	root.load_overworld()
