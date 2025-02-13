class_name HasteStatus
extends StatusEffect

# --- Variables --- #


# --- Functions --- #
func setup_signals() -> void:
	entity.turn_ended.connect(_on_turn_ended)

func _on_turn_ended(_params: Dictionary) -> void:
	entity.turn.actions_remaining += 1
	decrement_stacks()
