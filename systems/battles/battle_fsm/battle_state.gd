class_name BattleState
extends Node2D

# --- References --- #
@onready var fsm: BattleFsm = $".."
@onready var root: BattleManager = $"../.."

# --- Functions --- #
func state_entered() -> void:
	pass

func entity_removed(entity: Entity) -> void:
	pass

func action_performed() -> void:
	pass
