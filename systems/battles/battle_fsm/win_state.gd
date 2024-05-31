class_name WinState
extends BattleState

# --- Functions --- #
func state_entered() -> void:
	print("Victory!")
	root.load_overworld()
