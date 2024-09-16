class_name PlayerState
extends EntityTurnState

# --- Functions --- #
func state_entered() -> void:
	# Setup state
	group_name = &'player'
	next_state = 'enemy'
	super()
