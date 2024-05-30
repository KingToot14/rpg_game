class_name PlayerState
extends EntityTurnState

# --- Functions --- #
func state_entered():
	# Setup state
	group = root.players
	next_state = 'enemy'
	super()
