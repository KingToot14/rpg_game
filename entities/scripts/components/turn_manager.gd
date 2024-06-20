class_name TurnManager
extends Node

# --- Signals --- #
signal turn_ended()

# --- Variables --- #
var actions_remaining: int = 0

# --- References --- #
var parent: Entity

# --- Functions --- #
func _ready() -> void:
	parent = $"../.." as Entity

func take_turn() -> void:
	for effect in parent.status_effects.get_effects():
		effect.turn_started()
	
	parent.status_effects.remove_effects()
	
	if parent.brain:
		parent.brain.perform_turn()

func replenish_actions() -> void:
	actions_remaining = 1

func end_turn() -> void:
	turn_ended.emit()
	
	actions_remaining -= 1

func can_act() -> bool:
	return parent.hp.alive and actions_remaining > 0
