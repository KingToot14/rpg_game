class_name ActionState
extends Node2D

# --- Variables --- #
@onready var fsm = $".." as BattleActionManager
@onready var root = $'../..' as BattleManager

var target: Entity

# --- Functions --- #
func state_entered() -> void:
	pass

func perform_action() -> void:
	pass

func entity_selected(entity: Entity) -> void:
	pass

func highlight_targets() -> void:
	pass
