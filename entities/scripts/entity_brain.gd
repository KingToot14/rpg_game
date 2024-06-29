class_name EntityBrain
extends Node

# --- Variables --- #
@export var action_delay: float = 0.5

# --- References --- #
@onready var parent := $"../.." as Entity

# --- Functions --- #
func _on_turn_started() -> void:
	await get_tree().create_timer(action_delay).timeout
	perform_turn()

func perform_turn() -> void:
	return
