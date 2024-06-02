class_name PlayerState
extends EntityTurnState

# --- Functions --- #
func state_entered():
	# Setup state
	group_name = &'player'
	next_state = 'enemy'
	super()
