class_name WetStatus
extends StatusEffect

# --- Variables --- #


# --- Functions --- #
func setup_signals() -> void:
	entity.turn_ended.connect(_root_turn_ended)

func set_status_info() -> void:
	max_stack = 100
	
	icon_pos = Vector2(1, 1)
	
	key = &'wet'
