class_name ChangeTurnTactic
extends Tactic

# --- Variables --- #


# --- Functions --- #
func do_tactic() -> void:
	Globals.turn_fsm.set_entity(Globals.curr_target)

func highlight_targets() -> void:
	var players = TargetingHelper.get_alive_entities(&'player')
	
	for player in players:
		if player.can_act():
			player.set_targetable(true)

