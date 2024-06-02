class_name EnemyState
extends EntityTurnState

# --- Functions --- #
func state_entered():
	# Setup state
	group_name = &'enemy'
	next_state = 'player'
	super()
