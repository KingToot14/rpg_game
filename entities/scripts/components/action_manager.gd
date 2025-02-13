class_name ActionManager
extends Node

# --- Variables --- #
@export var default_attack: Attack
@export var attack_pool: Array[Attack]

# --- Functions --- #
func _ready() -> void:
	var entity := $'../..' as Entity
	
	entity.turn_ended.connect(_on_turn_ended)

func _on_turn_ended(_params := {}) -> void:
	for attack in attack_pool:
		attack.decrement_cooldown()

func get_attack(key: StringName) -> Attack:
	for attack: Attack in attack_pool:
		if attack.animation_name == key:
			return attack
	
	return
