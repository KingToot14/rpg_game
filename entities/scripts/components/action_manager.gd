class_name ActionManager
extends Node

# --- Variables --- #
@export var default_attack: Attack
@export var attack_pool: Array[Attack]

# --- Functions --- #
func _on_turn_ended() -> void:
	for attack in attack_pool:
		attack.decrement_cooldown()

func get_attack(key: StringName) -> Attack:
	for attack: Attack in attack_pool:
		if attack.animation_name == key:
			return attack
	
	return
