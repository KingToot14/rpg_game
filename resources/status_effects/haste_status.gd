class_name HasteStatus
extends StatusEffect

# --- Variables --- #


# --- Functions --- #
func set_status_info() -> void:
	name = "Haste"
	key = &'haste'

func turn_ended() -> void:
	entity.turn.actions_remaining += 1
	
	super()
