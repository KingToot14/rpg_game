class_name EnemyState
extends EntityTurnState

# --- Functions --- #
func state_entered():
	# Setup state
	group = root.enemies
	next_state = 'player'
	super()
