class_name LoseState
extends BattleState

# --- Functions --- #
func state_entered() -> void:
	print("Loss :(")
	root.load_overworld()
