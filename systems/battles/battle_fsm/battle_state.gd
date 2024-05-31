class_name BattleState
extends Node2D

# --- References --- #
@onready var fsm: BattleFsm = $".."
@onready var root: BattleManager = $"../.."

# --- Functions --- #
func state_entered() -> void:
	print("state entered")

func entity_removed(entity: Entity) -> void:
	print("entity removed: ", entity)

func action_performed() -> void:
	print("action performed")

func state_exited() -> void:
	print("state exited")
