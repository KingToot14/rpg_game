class_name PlayerState
extends EntityTurnState

# --- Functions --- #
func state_entered() -> void:
	# Setup state
	group_name = &'player'
	next_state = 'enemy'
	super()

func state_exited() -> void:
	TargetingHelper.disable_highlights()

func item_set() -> void:
	# highlight targets
	var item = Globals.curr_item
	
	if item:
		item.highlight_targets()
