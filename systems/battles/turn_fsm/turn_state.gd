class_name TurnState
extends Node2D

# --- References --- #
@onready var fsm: TurnFSM = $".."
@onready var root: EncounterManager = $"../.."

# --- Functions --- #
func state_entered() -> void:
	pass

func entity_removed(entity: Entity) -> void:
	pass

func action_performed() -> void:
	pass
