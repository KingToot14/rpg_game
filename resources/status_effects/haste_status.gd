class_name HasteStatus
extends StatusEffect

# --- Variables --- #


# --- Functions --- #
func setup_signals() -> void:
	entity.turn_ended.connect(_on_turn_ended)

func set_status_info() -> void:
	icon_pos = Vector2(0, 2)
	
	key = &'haste'
	name = "Haste"
	description = "Takes an extra turn after this one"

func _on_turn_ended(_params: Dictionary) -> void:
	entity.turn.actions_remaining += 1
	decrement_stacks()
