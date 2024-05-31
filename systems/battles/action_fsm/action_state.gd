class_name ActionState
extends Node2D

# --- Variables --- #
@onready var fsm = $".." as BattleActionManager
@onready var root = $'../..' as BattleManager

var target: Entity

# --- Functions --- #
func state_entered() -> void:
	print("state entered")

func perform_action() -> void:
	print("action performed")

func entity_selected(entity: Entity) -> void:
	print("entity selected: ", entity)

func highlight_targets() -> void:
	print("targetting highlights")
