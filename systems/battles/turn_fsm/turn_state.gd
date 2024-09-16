class_name TurnState
extends Node2D

# --- References --- #
@onready var fsm: TurnFSM = $".."
@onready var root: EncounterManager = $"../.."

@export var group_name: StringName
@export var next_state: String

# --- Functions --- #
func state_entered() -> void:
	pass

func state_exited() -> void:
	pass

func entity_removed(_entity: Entity) -> void:
	pass

func item_set() -> void:
	pass

func action_performed() -> void:
	pass
