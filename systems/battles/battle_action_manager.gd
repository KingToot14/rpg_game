class_name BattleActionManager
extends Node2D

# --- Signals --- #
signal action_performed()

# --- Variables --- #
@export_group("Player Turn")
@export var action_bar: Control

# --- Functions --- #
func perform_action() -> void:
	action_performed.emit()

func _on_state_changed(state: String) -> void:
	set_action_bar(state == 'player')

# - Player - #
func set_action_bar(value: bool) -> void:
	action_bar.visible = value
