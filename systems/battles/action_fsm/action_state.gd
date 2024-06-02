class_name ActionState
extends Node2D

# --- Variables --- #
@onready var fsm = $".." as ActionFSM

# --- Functions --- #
func state_entered() -> void:
	pass

func perform_action() -> void:
	pass

func entity_selected(_entity: Entity) -> void:
	pass

func highlight_targets() -> void:
	pass
