class_name TurnManager
extends Node

# --- Signals --- #
signal turn_started()
signal turn_ended()

# --- Variables --- #
var actions_remaining: int = 0
var taking_turn := false

var visited_before := false

# --- References --- #
var parent: Entity

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity

func take_turn() -> void:
	for entity in get_tree().get_nodes_in_group(&'entity'):
		entity.turn.taking_turn = false
	
	taking_turn = true
	turn_started.emit()

func replenish_actions() -> void:
	actions_remaining = 1

func end_turn() -> void:
	taking_turn = false
	turn_ended.emit()

func can_act() -> bool:
	return parent.hp.alive and actions_remaining > 0
