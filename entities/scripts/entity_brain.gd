class_name EntityBrain
extends Node

# --- Variables --- #
@export var action_delay: float = 0.5

# --- References --- #
@onready var parent := $"../.." as Entity

# --- Functions --- #
func perform_turn() -> void:
	await get_tree().create_timer(action_delay).timeout
	
	select_action()
	select_attack()
	select_target()

func select_action() -> void:
	print("selecting action")

func select_target() -> void:
	print("select target")

func select_attack() -> void:
	print("selecting attack")
