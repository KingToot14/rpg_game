class_name TurnManager
extends Node

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
	parent.turn_started.emit({&'visited_before': visited_before})
	
	visited_before = true

func replenish_actions() -> void:
	actions_remaining = 1

func end_turn() -> void:
	taking_turn = false
	parent.turn_ended.emit()
	
	visited_before = false

func can_act() -> bool:
	return parent.hp.alive and actions_remaining > 0
