class_name TurnManager
extends Node

# --- Signals --- #
signal turn_started()
signal turn_ended()

# --- Variables --- #
var actions_remaining: int = 0

# --- References --- #
var parent: Entity

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity

func take_turn() -> void:
	turn_started.emit()

func replenish_actions() -> void:
	actions_remaining = 1

func end_turn() -> void:
	turn_ended.emit()
	
	actions_remaining -= 1

func can_act() -> bool:
	return parent.hp.alive and actions_remaining > 0
