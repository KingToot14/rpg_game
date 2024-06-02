class_name LoseState
extends TurnState

# --- Functions --- #
func state_entered() -> void:
	print("Loss :(")
	root.load_overworld()
